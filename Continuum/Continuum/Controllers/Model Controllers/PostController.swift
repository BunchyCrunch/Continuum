//
//  PostController.swift
//  Continuum
//
//  Created by Josh Sparks on 10/15/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation
import UIKit

class PostController {
    
    static let shared = PostController()
    
    var posts: [Post] = []
    
    
    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> Void ) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
    }
    
    func createPostWith(photo: UIImage, caption: String, completion: @escaping (Post?) -> Void) {
        let post = Post(photo: photo, caption: caption)
        self.posts.append(post)
    }
    
} // end of class
