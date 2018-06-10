//
//  Post.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import Foundation

struct Post: Codable, Equatable {
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    let author: String
    let text: String
    let postedAt: Date
    
    init(author: String, text: String) {
        self.id = NSUUID().uuidString
        self.author = author
        self.text = text
        self.postedAt = Date()
    }
}
