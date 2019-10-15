//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Josh Sparks on 10/15/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postPhotoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        postPhotoImageView.image = post?.photo
        captionLabel.text = post?.caption
        commentCountLabel.text = "\(post?.commentCount ?? 0)"
    }
}
