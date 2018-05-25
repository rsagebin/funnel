//
//  FeedTableViewCell.swift
//  funnel
//
//  Created by Alec Osborne on 5/16/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

protocol CommentsDelegate {
    func didTapComment(post: Post)
}

protocol SuggestionDelegate {
    func postSuggestionButtonTapped(post: Post)
}

class FeedTableViewCell: UITableViewCell {

    // MARK: - Properties
    var commentsDelegate: CommentsDelegate?
    
    var suggestDelegate: SuggestionDelegate?
    
    var post: Post? {
        didSet {
            checkIfUserIsFollowing()
            
            updateViews()
        }
    }
    
    var isFollowing = false

    
    // MARK: - Outlets
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var frontView: UIView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postApprovedImage: UIImageView!
    @IBOutlet weak var postFollowingCountLabel: UILabel!
    @IBOutlet weak var postFollowingButton: UIButton!
    @IBOutlet weak var postSuggestionCountLabel: UILabel!
    @IBOutlet weak var postSuggestionButton: UIButton!
    @IBOutlet weak var postCommentsCountLabel: UILabel!
    @IBOutlet weak var commentsButtonOutlet: UIButton!
    
    // MARK: - Actions
    @IBAction func postFollowingButtonTapped(_ sender: UIButton) {
        
        guard let user = UserController.shared.loggedInUser else { return }
        guard let post = self.post else { return }
        
        isFollowing = !isFollowing
        
        if isFollowing == true {
            PostController.shared.addFollowerToPost(user: user, post: post)

        } else if isFollowing == false {
            PostController.shared.removeFollowerFromPost(user: user, post: post)
        }
        updateViews()
    }
    
    func checkIfUserIsFollowing() {
        isFollowing = false
        guard let userID = UserController.shared.loggedInUser else { return }
        let userRef = CKReference(recordID: userID.ckRecordID ?? userID.ckRecord.recordID, action: .none)
        guard let followersRefs = post?.followersRefs else { return }
        
        for refNumber in followersRefs {
            if refNumber == userRef {
                isFollowing = true
                return
            }
        }
    }
    
    @IBAction func postSuggestButtonTapped(_ sender: UIButton) {
        guard let post = post else { return }
        suggestDelegate?.postSuggestionButtonTapped(post: post)
        print("suggestionButton tapped")
    }
    
    @IBAction func commentsButtonTapped(_ sender: Any) {
        print("Trying to show comments...")
        guard let post = post else { return }
        commentsDelegate?.didTapComment(post: post)
    }
    
    // MARK: - Other Functions
    func updateViews() {
        if let post = post {
            
            backView.layer.cornerRadius = 5
            frontView.layer.cornerRadius = 3
            
            guard let buttonImage = postFollowingButton.imageView else { return }
            
            self.postApprovedImage.isHidden = true
            self.categoriesLabel.text = post.categoryAsString
            self.descriptionTextView.text = post.description
            self.postImageView.image = post.image
            self.postFollowingCountLabel.text = String(post.followersRefs.count)
//            self.postSuggestionCountLabel.text =
//            self.postCommentsCountLabel.text = String(comments.count)
            
//            if postFollowingCountLabel.text == String(0) {
//                buttonImage.tintColor = UIColor.black
//            }
            
            if isFollowing == true {
                buttonImage.tintColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
            } else {
                buttonImage.tintColor = UIColor.black
            }
        }
    }
    
    
    
}
