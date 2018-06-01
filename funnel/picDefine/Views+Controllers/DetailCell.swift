//
//  DetailCell.swift
//  funnel
//
//  Created by Alec Osborne on 5/16/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

class DetailCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var postSubmittedImage: UIImageView!
    @IBOutlet weak var postAcceptedSolutionIcon: UIImageView!
    @IBOutlet weak var postCategoryLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postHashTagsLabel: UILabel!
    @IBOutlet weak var postFollowingLabel: UILabel!
    @IBOutlet weak var postFollowingButton: UIButton!
    @IBOutlet weak var postSuggestionLabel: UILabel!
    @IBOutlet weak var postSuggestionButton: UIButton!
    @IBOutlet weak var postCommentsLabel: UILabel!
    @IBOutlet weak var postCommentsButton: UIButton!
    
    
    // MARK: - Properties
    var userPost: Post? {
        didSet {
            
            checkUserRef()
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
            checkUserRef()
        }
    }
    
    var userFollowing: Post? {
        didSet {
            checkUserRef()
            if let following = userFollowing {
                guard let buttonImage = postFollowingButton.imageView else { return }
                postSubmittedImage.image = following.image
                postAcceptedSolutionIcon.isHidden = true // Create check function
                postCategoryLabel.text = following.categoryAsString
                postDescriptionLabel.text = following.description
//                postHashTagsLabel.text =
                postFollowingLabel.text = String(following.followersRefs.count)
                buttonImage.tintColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
//                postSuggestionLabel.text =
//                postCommentsLabel.text =
            }
        }
    }
    
    var isFollowing = false
    
    // MARK: - Actions
    @IBAction func postFollowingButtonTapped(_ sender: UIButton) {
//        
//        guard let user = UserController.shared.loggedInUser else { return }
//        guard let post = self.userPost else { return }
//
//        isFollowing = !isFollowing
//
//        if isFollowing == true {
//            PostController.shared.addFollowerToPost(user: user, post: post)
//
//        } else if isFollowing == false {
//            PostController.shared.removeFollowerFromPost(user: user, post: post)
//        }
    }
    
    @IBAction func postSuggestionButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func postCommentsButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Methods
    func checkUserRef() {
//        guard let userID = UserController.shared.loggedInUser else { return }
//        let userRef = CKReference(recordID: userID.ckRecordID ?? userID.ckRecord.recordID, action: .none)
//        guard let followersRefs = userPost?.followersRefs else { return }
//
//        for refNumber in followersRefs {
//            if refNumber == userRef {
//                isFollowing = true
//            }
//        }
    }
}
