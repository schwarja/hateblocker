//
//  PostsManager.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import Foundation

protocol PostsManagerDelegate: class {
    func postsManagerDidUpdate(_ manager: PostsManager)
}

class PostsManager {
    private let firebase: FirebaseManager
    
    weak var delegate: PostsManagerDelegate?
    
    private(set) var posts: [Post] = [] {
        didSet {
            managerUpdated()
        }
    }
    
    init(firebase: FirebaseManager) {
        self.firebase = firebase
        
        startObserving()
    }
    
    func sendPost(withName name: String, text: String) {
        let post = Post(author: name, text: text)
        firebase.write(object: post, atPath: .posts)
    }
    
    func deletePosts() {
        firebase.delete(path: .posts)
    }
}

private extension PostsManager {
    func startObserving() {
        firebase.listenTo(path: .posts) { [weak self] (operation: FirebaseManager.Operation, post: Post) -> Void in
            switch operation {
            case .added:
                self?.posts.append(post)
            case .updated:
                if let index = self?.posts.index(of: post), var postsCopy = self?.posts {
                    postsCopy.remove(at: index)
                    postsCopy.insert(post, at: index)
                    self?.posts = postsCopy
                }
            case .removed:
                if let index = self?.posts.index(of: post) {
                    self?.posts.remove(at: index)
                }
            }
        }
    }
    
    func managerUpdated() {
        DispatchQueue.main.async {
            self.delegate?.postsManagerDidUpdate(self)
        }
    }
}
