//
//  PostDetailTableViewController.swift
//  funnel
//
//  Created by Alec Osborne on 5/16/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

class PostDetailViewController: UIViewController {

    // MARK: - Properties
    
    var post: Post?
    var isFollowing = false
    var comments = [Comment]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var postApprovedImage: UIImageView!
    
    @IBOutlet weak var tagsTextView: UITextView!
    
    @IBOutlet weak var postFollowingCountLabel: UILabel!
    @IBOutlet weak var postFollowingButton: UIButton!
    @IBOutlet weak var postSuggestCountLabel: UILabel!
    @IBOutlet weak var branchButtonOutlet: UIButton!
    @IBOutlet weak var postCommentCountLabel: UILabel!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton()
        postApprovedImage.isHidden = true
        
        updateViews()
        
        guard let post = self.post else { return }
        
        checkIfUserCreatedPost()
        
        CommentController.shared.loadCommentsFor(post: post) { (success) in
            
            if success {
                DispatchQueue.main.async {
                    
                    self.comments = CommentController.shared.postComments
                    self.updateViews()
                    self.checkIfUserCreatedPost()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        tagsTextView.layer.borderColor = UIColor.black.cgColor
        tagsTextView.layer.borderWidth = 1.0
    }
    
    // MARK: - Other functions
    
    func updateViews() {
        
        guard let post = post else { return }
        let comments = CommentController.shared.postComments.count
        descriptionTextView.text = post.description
        categoryLabel.text = post.categoryAsString
        postImageView.image = post.image
        postFollowingCountLabel.text = String(post.followersRefs.count)
//        postSuggestCountLabel.text =
        postCommentCountLabel.text = String(comments)
        
        TagController.shared.fetchTagsFor(post: post) { (tags) in
            DispatchQueue.main.async {
                self.tagsTextView.text = tags
            }
        }
    }
    
    func checkIfUserCreatedPost() {
        guard let post = post else { return }
        guard let user = UserController.shared.loggedInUser?.appleUserRef else { return }
        let postCreator = CKReference(recordID: post.ckRecordID ?? post.ckRecord.recordID, action: .none)
        
        if user == postCreator {
            // Not working
        }
    }
    
    func createButton() {
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePost))
        deleteButton.tintColor = UIColor.red
        self.navigationItem.rightBarButtonItem = deleteButton
    }
    
    @objc func deletePost() {
        guard let post = post else { return }
        PostController.shared.delete(post: post)
        NotificationCenter.default.post(name: Notification.Name(PostController.feedFetchCompletedNotificationName), object: nil)
        
    }
  
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
    
    @IBAction func branchPostButtonTapped(_ sender: Any) {
        print("button is working")
        let mySB = UIStoryboard(name: "CreateAndSuggest", bundle: .main)
        let vc = mySB.instantiateViewController(withIdentifier: "PostAndSubmitSB") as! CreateAndSuggestViewController
        vc.post = self.post
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func commentsButtonTapped(_ sender: Any) {
        print("Trying to show comments")
        print(post?.description)
        let commentsSB = UIStoryboard(name: "Comments", bundle: .main)
        let commentsController = commentsSB.instantiateViewController(withIdentifier: "CommentsSB") as! CommentsTableViewController
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
}
