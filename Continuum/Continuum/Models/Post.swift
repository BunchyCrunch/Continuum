//
//  Post.swift
//  Continuum
//
//  Created by Josh Sparks on 10/15/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var photoData: Data?
    let timestamp: Date
    let caption: String
    var comments: [Comment]
    let commentCount: Int
    
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(photo: UIImage, caption: String, timestamp: Date = Date(), comments: [Comment] = [], commentCount: Int = 0) {
        self.caption = caption
        self.timestamp = timestamp
        self.comments = comments
        self.commentCount = commentCount
        self.photo = photo
    }
} // end of class

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if caption.contains(searchTerm) {
            return true
        } else {
            for comment in comments {
                if comment.matches(searchTerm: searchTerm) {
                    return true
                }
            }
        }
        return true
    }
}
