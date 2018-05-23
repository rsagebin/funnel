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
            if let post = userPost {
                self.postSubmittedImage.image = post.image
                self.postAcceptedSolutionIcon.isHidden = true // Call function when suggestions are there
                self.postCategoryLabel.text = post.categoryAsString
                self.postDescriptionLabel.text = post.description
//                self.postHashTagsLabel.text =
                self.postFollowingLabel.text = String(post.followersRefs.count)
//            self.postSuggestionLabel.text =
//            self.postCommentsLabel.text =
            }
        }
    }
    
    var userSuggestion: Post? {
        didSet {
            
        }
    }
    
    var userFollowing: Post? {
        didSet {
            if let following = userFollowing {
                postSubmittedImage.image = following.image
//                postAcceptedSolutionIcon =
                postCategoryLabel.text = following.categoryAsString
                postDescriptionLabel.text = following.description
//                postHashTagsLabel.text =
                postFollowingLabel.text = String(following.followersRefs.count)
//                postSuggestionLabel.text =
//                postCommentsLabel.text =
            }
        }
    }
}
