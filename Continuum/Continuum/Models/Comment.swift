//
//  Comment.swift
//  Continuum
//
//  Created by Josh Sparks on 10/15/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation

class Comment {
    let text: String
    let timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
}