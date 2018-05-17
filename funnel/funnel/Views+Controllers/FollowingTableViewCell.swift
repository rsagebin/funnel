//
//  FollowingTableViewCell.swift
//  funnel
//
//  Created by Alec Osborne on 5/16/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class FollowingTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var postCategoryLabel: UILabel!
    @IBOutlet weak var postSubmittedImage: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var postFollowingLabel: UILabel!
    @IBOutlet weak var postCuriosityLabel: UILabel!
    @IBOutlet weak var postSuggestionLabel: UILabel!
    @IBOutlet weak var postCommentsLabel: UILabel!
    
    
    // MARK: - Properties
    var post: MockPost? {
        didSet {
            updateViews()
        }
    }
    
    var user: MockUser? {
        didSet {
            updateViews()
        }
    }
    
    
    // MARK: - Methods
    func updateViews() {
        if let post = post {
            self.postCategoryLabel.text = post.category
            self.postSubmittedImage.image = post.image
//            self.userProfileImage.image = user.
//            self.postFollowingLabel.text = post.
//            self.postCuriosityLabel.text = post.
//            self.postSuggestionLabel.text = post.
            self.postCommentsLabel.text = post.comments
        }
    }
}
