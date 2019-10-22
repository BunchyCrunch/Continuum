//
//  PostController.swift
//  Continuum
//
//  Created by Josh Sparks on 10/15/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import CloudKit
import UIKit

class PostController {
    
    static let shared = PostController()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    var posts: [Post] = []
    
    
    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> Void ) {
        let comment = Comment(text: text, post: post)
        
        let record = CKRecord(comment: comment)
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            
            guard let record = record,
            let comment = Comment(ckRecord: record, post: post) else { completion(nil) ; return }
            post.comments.append(comment)
        }
    }
    
    func createPostWith(photo: UIImage, caption: String, completion: @escaping (Post?) -> Void) {
        let post = Post(photo: photo, caption: caption)
        let record = CKRecord(post: post)
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            
            guard let record = record,
                let post = Post(ckRecord: record) else { completion(nil) ; return }
            self.posts.append(post)
            print("Post created")
            completion(post)
        }
    }
    
} // end of class
