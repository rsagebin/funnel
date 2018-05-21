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
    @IBOutlet weak var postSubmittedImage: UIImageView!
    @IBOutlet weak var postAcceptedSolutionIcon: UIImageView!
    @IBOutlet weak var postCategoryLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postHashTagsLabel: UILabel!
    @IBOutlet weak var postFollowingLabel: UILabel!
    @IBOutlet weak var postSuggestionLabel: UILabel!
    @IBOutlet weak var postCommentsLabel: UILabel!
    
    
    // MARK: - Properties
    var userPost: Post? {
        didSet {
            updateViews()
        }
    }
    
    var userSuggestion: Post? {
        didSet {
            updateViews()
        }
    }
    
    var userFollowing: Post? {
        didSet {
            updateViews()
        }
    }
    
    
    // MARK: - Methods
    func updateViews() {
        if let post = userPost {
            self.postSubmittedImage.image = post.image
            self.postAcceptedSolutionIcon.isHidden = true
            self.postCategoryLabel.text = post.category
            self.postDescriptionLabel.text = post.description
            self.postHashTagsLabel.text = ""
            self.postFollowingLabel.text = String(post.followersRefs.count)
//            self.postSuggestionLabel.text = post
//            self.postCommentsLabel.text = "\(post.comments?.count)" ?? "\(0)"
        }
        
        // Post solution unhide accepted soulution
    }
}
