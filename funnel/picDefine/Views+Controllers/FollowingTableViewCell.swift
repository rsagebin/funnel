//
//  FollowingTableViewCell.swift
//  funnel
//
//  Created by Alec Osborne on 5/16/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

class FollowingTableViewCell: UITableViewCell {

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
            let comments = CommentController.shared.postComments.count
            if let post = userPost {
                self.postSubmittedImage.image = post.image
                self.postAcceptedSolutionIcon.isHidden = true // Call function when suggestions are there
                self.postCategoryLabel.text = post.categoryAsString
                self.postDescriptionLabel.text = post.description
//                self.postHashTagsLabel.text =
                self.postFollowingLabel.text = String(post.followersRefs.count)
            self.postSuggestionLabel.text = String(RevisedPostController.shared.revisedPostsToApprove.count) // Refactor if possible
            self.postCommentsLabel.text = String(comments)
            }
        }
    }
    
    var userFollowing: Post? {
        didSet {
            checkUserRef()
            let comments = CommentController.shared.postComments.count
            if let following = userFollowing {
                postSubmittedImage.image = following.image
                postAcceptedSolutionIcon.isHidden = true // Create check function
                postCategoryLabel.text = following.categoryAsString
                postDescriptionLabel.text = following.description
                postFollowingLabel.text = String(following.followersRefs.count)
                postSuggestionLabel.text = String(RevisedPostController.shared.revisedPostsToApprove.count) // Refactor if possible
                postCommentsLabel.text = String(comments)
            }
        }
    }
    
    var communitySuggestion: RevisedPost? {
        didSet {
            let comments = CommentController.shared.postComments.count
            if let suggestion = communitySuggestion {
                postSubmittedImage.image = suggestion.image
                postAcceptedSolutionIcon.isHidden = true
                postCategoryLabel.text = suggestion.categoryAsString
                postDescriptionLabel.text = suggestion.description
                postFollowingLabel.isHidden = true
                postFollowingButton.isHidden = true
                postSuggestionLabel.text = String(RevisedPostController.shared.revisedPostsToApprove.count)
                postCommentsLabel.text = String(comments)
            }
        }
    }
    
    var userSuggestion: RevisedPost? {
        didSet {
            checkUserRef()
            let comments = CommentController.shared.postComments.count
            if let suggestion = userSuggestion {
                postSubmittedImage.image = suggestion.image
                postAcceptedSolutionIcon.isHidden = true
                postCategoryLabel.text = suggestion.categoryAsString
                postDescriptionLabel.text = suggestion.description
                postFollowingLabel.isHidden = true
                postFollowingButton.isHidden = true
                postSuggestionLabel.text = String(RevisedPostController.shared.revisedPostsUserCreated.count) // Refactor if possible
                postCommentsLabel.text = String(comments)
            }
        }
    }
    
//    var suggestionCount Int
    
//    func fetchSuggestionCount() {
//
//        PostController.shared.
//
//        RevisedPostController.shared.fetchNumberOfSuggestionsFor(post: <#T##Post#>) { (count) in
//            <#code#>
//        }
//    }
    
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
        
//        let commentsSB = UIStoryboard(name: "Comments", bundle: .main)
//        let commentsVC = commentsSB.instantiateViewController(withIdentifier: "CommentsSB") as! CommentsTableViewController
//        commentsVC.post = userPost
//        navigationController?.pushViewController(commentsVC, animated: true) Needs to be moved to the TableVC
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
