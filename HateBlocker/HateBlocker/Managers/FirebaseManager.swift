//
//  FirebaseManager.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

enum FirebasePath: String {
    case posts
}

class FirebaseManager {
    enum Operation {
        case added
        case updated
        case removed
    }
    
    private let reference: DatabaseReference!
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }()

    private var postsObserver: (added: UInt, updated: UInt, removed: UInt)?
    
    init() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        reference = Database.database().reference()
    }
    
    func write<Object: Encodable>(object: Object, atPath path: FirebasePath) {
        if let data = try? encoder.encode(object),
            let dict = try? JSONSerialization.jsonObject(with: data, options: []) {
            reference.child(path.rawValue).childByAutoId().setValue(dict)
        }
    }
    
    func listenTo<Object: Decodable>(path: FirebasePath, block: @escaping (_ operation: Operation, _ post: Object) -> Void) {
        reference.child(FirebasePath.posts.rawValue).observe(.childAdded) { [weak self] snapshot in
            if let data = snapshot.data {
                do {
                    if let post = try self?.decoder.decode(Object.self, from: data) {
                        block(.added, post)
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        reference.child(FirebasePath.posts.rawValue).observe(.childChanged) { [weak self] snapshot in
            if let data = snapshot.data {
                do {
                    if let post = try self?.decoder.decode(Object.self, from: data) {
                        block(.updated, post)
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        reference.child(FirebasePath.posts.rawValue).observe(.childRemoved) { [weak self] snapshot in
            if let data = snapshot.data {
                do {
                    if let post = try self?.decoder.decode(Object.self, from: data) {
                        block(.removed, post)
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func delete(path: FirebasePath) {
        reference.child(path.rawValue).removeValue()
    }
}
