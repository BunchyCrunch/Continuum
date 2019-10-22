//
//  Post.swift
//  Continuum
//
//  Created by Josh Sparks on 10/15/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import CloudKit
import UIKit

struct PostConstants {
    static let typeKey = "Post"
    static let captionKey = "caption"
    static let timestampKey = "timestamp"
    static let commentsKey = "comments"
    static let photoKey = "photoAsset"
    static let commentCountKey = "commentCount"
}

class Post {
    var photoData: Data?
    let timestamp: Date
    let caption: String
    var comments: [Comment]
    let commentCount: Int
    let recordID: CKRecord.ID
    
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURl = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURl.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(photo: UIImage?, caption: String, timestamp: Date = Date(), comments: [Comment] = [], commentCount: Int = 0, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.caption = caption
        self.comments = comments
        self.commentCount = commentCount
        self.recordID = recordID
        self.timestamp = timestamp
        self.photo = photo
    }

    convenience init?(ckRecord: CKRecord) {
        guard let caption = ckRecord[PostConstants.captionKey] as? String,
        let timestamp = ckRecord [PostConstants.timestampKey] as? Date,
        let commentCount = ckRecord[PostConstants.commentCountKey] as? Int
        else { return nil }

        var postPhoto: UIImage?
        if let photoAsset = ckRecord[PostConstants.photoKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                postPhoto = UIImage(data: data)
            } catch {
                print("Post: could not transform asset to data")
            }
        }

        self.init(photo: postPhoto, caption: caption, timestamp: timestamp, commentCount: commentCount, recordID: ckRecord.recordID)
    }
    
//    init?(ckRecord: CKRecord) {
//      do{
//      guard let caption = ckRecord[PostConstants.captionKey] as? String,
//        let timestamp = ckRecord[PostConstants.timestampKey] as? Date,
//        let photoAsset = ckRecord[PostConstants.photoKey] as? CKAsset,
//        let commentCount = ckRecord[PostConstants.commentCountKey] as? Int
//        else { return nil}
//
//        let photoData = try Data(contentsOf: photoAsset.fileURL)
//        self.caption = caption
//        self.timestamp = timestamp
//        self.photoData = photoData
//        self.recordID = ckRecord.recordID
//        self.commentCount = commentCount
//        self.comments = []
//      }catch {
//        print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
//        return nil
//      }
//    }
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

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostConstants.typeKey, recordID: post.recordID)
        self.setValue(post.caption, forKey: PostConstants.captionKey)
        self.setValue(post.commentCount, forKey: PostConstants.commentCountKey)
        self.setValue(post.timestamp, forKey: PostConstants.timestampKey)
        self.setValue(post.imageAsset, forKey: PostConstants.photoKey)
    }
}
