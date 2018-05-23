//
//  FeedTableViewCell.swift
//  funnel
//
//  Created by Alec Osborne on 5/16/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

protocol CommentsDelegate {
    func didTapComment(post: Post)
}

//protocol SuggestionDelegate {
//    func postSuggestionButtonTapped(post: Post)
//}

class FeedTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var delegate: CommentsDelegate?
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    var isFollowing = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagsTextView: UITextView!
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
        guard let buttonImage = postFollowingButton.imageView else { return }
        
        isFollowing = !isFollowing
        
        if isFollowing == true {
            buttonImage.tintColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
            PostController.shared.addFollowerToPost(user: user, post: post)

        } else if isFollowing == false {
            buttonImage.tintColor = UIColor.black
            PostController.shared.removeFollowerFromPost(user: user, post: post)
        }
        updateViews()
    }
    
    @IBAction func postSuggestButtonTapped(_ sender: UIButton) {
//        guard let post = post else { return }
//        delegate?.didTapComment(post: post)
    }
    
    @IBAction func commentsButtonTapped(_ sender: Any) {
        print("Trying to show comments...")
        guard let post = post else { return }
        delegate?.didTapComment(post: post)
    }
    
    // MARK: - Other Functions
    
    func updateViews() {
        if let post = post {
            guard let user = UserController.shared.loggedInUser else { return }
            let comments = CommentController.shared.postComments.count
            
            self.postApprovedImage.isHidden = true
            self.categoriesLabel.text = post.categoryAsString
            self.descriptionTextView.text = post.description
            self.postImageView.image = post.image
            self.postFollowingCountLabel.text = String(post.followersRefs.count)
//            self.postSuggestionCountLabel.text =
//            self.postCommentsCountLabel.text =
        }
    }
    
    
}
