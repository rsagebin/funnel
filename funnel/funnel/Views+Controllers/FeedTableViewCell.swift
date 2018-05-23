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
    @IBOutlet weak var exclamationButtonOutlet: UIButton!
    @IBOutlet weak var commentsButtonOutlet: UIButton!
    
    @IBOutlet weak var branchButtonOutlet: UIButton!
    @IBOutlet weak var aprovedButtonOutlet: UIButton!
   
    // MARK: - Actions
    
    @IBAction func postFollowingButtonTapped(_ sender: UIButton) {
        
        guard let user = UserController.shared.loggedInUser else { return }
        guard let post = self.post else { return }
        guard let buttonImage = exclamationButtonOutlet.imageView else { return }
        
        isFollowing = !isFollowing
        
        if isFollowing == true {
            buttonImage.tintColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
            PostController.shared.addFollowerToPost(user: user, post: post)

        } else if isFollowing == false {
            buttonImage.tintColor = UIColor.black
            PostController.shared.removeFollowerFromPost(user: user, post: post)
        }
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
            
            self.categoriesLabel.text = post.category
            self.descriptionTextView.text = post.description
            self.postImageView.image = post.image
        }
    }
}
