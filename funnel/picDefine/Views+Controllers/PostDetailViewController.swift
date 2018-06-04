//
//  PostDetailTableViewController.swift
//  funnel
//
//  Created by Alec Osborne on 5/16/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

class PostDetailViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Properties
    
    var post: Post?
    var user: User?
    var revisedPost: RevisedPost?
    var isFollowing = false
    var comments = [Comment]()
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var postApprovedImage: UIImageView!
    
    @IBOutlet weak var postFollowingCountLabel: UILabel!
    @IBOutlet weak var postFollowingButton: UIButton!
    @IBOutlet weak var postSuggestCountLabel: UILabel!
    @IBOutlet weak var branchButtonOutlet: UIButton!
    @IBOutlet weak var postCommentCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        createButton()
        checkIfUserIsFollowing()
        
        if let regularPost = self.post, regularPost.isAnswered {
            self.postApprovedImage.isHidden = false
        } else {
            self.postApprovedImage.isHidden = true
        }
        
        updatePostView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        guard let post = post else { return }
        guard let user = UserController.shared.loggedInUser else { return }
        
        UserController.shared.fetchUser(ckRecordID: post.creatorRef.recordID) { (user) in
            DispatchQueue.main.async {
                
                self.usernameLabel.text = user?.username
            }
        }
        
        CommentController.shared.loadCommentsFor(post: post) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.postCommentCountLabel.text = String(CommentController.shared.postComments.count)
                }
            }
        }
        
        RevisedPostController.shared.fetchNumberOfSuggestionsFor(post: post) { (success, number) in
            if success {
                DispatchQueue.main.async {
                    self.postSuggestCountLabel.text = String(number)
                }
            }
        }
     
        if post.creatorRef.recordID == user.ckRecordID {
            postFollowingButton.isEnabled = false
            branchButtonOutlet.isEnabled = false
        }
        
        updatePostView()
    }


    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.postImageView
    }
    // MARK: - Other functions
    
    func checkIfUserIsFollowing() {
        isFollowing = false
        guard let userID = UserController.shared.loggedInUser else { return }
        let userRef = CKReference(recordID: userID.ckRecordID, action: .none)
        guard let followersRefs = post?.followersRefs else { return }
        
        for refNumber in followersRefs {
            if refNumber == userRef {
                isFollowing = true
                postFollowingButton.setImage(#imageLiteral(resourceName: "star-filled-500"), for: .normal)
                return
            }
        }
    }
    
    func updatePostView() {
    
        if post != nil {
            
            descriptionLabel.text = post?.description
            categoryLabel.text = post?.categoryAsString.uppercased()
            postImageView.image = post?.image
            postImageView.layer.borderColor = UIColor.lightGray.cgColor
            postImageView.layer.borderWidth = 1
            postFollowingCountLabel.text = "\(post?.followersRefs.count ?? 0)"

        } else if revisedPost != nil {
            descriptionLabel.text = revisedPost?.description
            categoryLabel.text = revisedPost?.categoryAsString.uppercased()
            postImageView.image = revisedPost?.image
            postImageView.layer.borderColor = UIColor.lightGray.cgColor
            postImageView.layer.borderWidth = 1

            postFollowingButton.isEnabled = false
            branchButtonOutlet.isEnabled = false
            commentButton.isEnabled = false
            
//            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func updateRevisedPostView() {
        guard let revisedPost = revisedPost else { return }
        let userSuggestionCount = RevisedPostController.shared.revisedPostsUserCreated.count
        let communitySuggestionCount = RevisedPostController.shared.revisedPostsToApprove.count
        let commentCount = CommentController.shared.postComments.count
        
        descriptionLabel.text = revisedPost.description
        categoryLabel.text = revisedPost.categoryAsString
        postImageView.image = revisedPost.image
        postSuggestCountLabel.text = String(userSuggestionCount + communitySuggestionCount) // What does this need to be? Check later
        postCommentCountLabel.text = String(commentCount)
    }
    
    func createButton() {
        
        if UserController.shared.loggedInUser?.ckRecordID == self.post?.creatorRef.recordID || UserController.shared.loggedInUser?.ckRecordID == revisedPost?.revisedPostCreatorRef.recordID {
            
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(createDeleteAlert))
            deleteButton.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = deleteButton
            
        } else {
            
            let optionButton = UIBarButtonItem(image: #imageLiteral(resourceName: "more-96"), style: .plain, target: self, action: #selector(createBlockAlert))
            optionButton.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = optionButton
        }
    }
    
    @objc func createBlockAlert() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let flagImage = UIAlertAction(title: "Flag Post", style: .destructive) { (_) in
            // flag post
            
            guard let post = self.post else { return }
            PostController.shared.flag(post: post, completion: { (success, ifFlagged) in
                
                if ifFlagged {
                    let alert = UIAlertController(title: "You already flagged this post.", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
                if success {
                    let alert = UIAlertController(title: "You successfully flagged this post.", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
        let blockUser = UIAlertAction(title: "Block User", style: .destructive) { (_) in
            // block user
            
            guard let post = self.post else { return }
            
            let alert = UIAlertController(title: "Are you sure you want to BLOCK this User?", message: "You won't be able to see posts from this user anymore.", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
                UserController.shared.block(userRecordID: post.creatorRef.recordID, completion: {(success) in
                
                })
                self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(cancel)
            alert.addAction(yesAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(flagImage)
        alert.addAction(blockUser)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func createDeleteAlert() {
        if post != nil {
            
            let alert = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                self.deletePost()
            }
            alert.addAction(deleteAction)
            
            present(alert, animated: true, completion: nil)
        } else if revisedPost != nil {
            
            let alert = UIAlertController(title: "Delete Suggested Post", message: "Are you sure you want to delete this suggested post?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                self.deleteSuggestedPost()
            }
            alert.addAction(deleteAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func deleteSuggestedPost() {
        guard let revisedPost = revisedPost else { return }
        RevisedPostController.shared.deleteRevisedPost(revisedPost: revisedPost) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func deletePost() {
        
        guard let post = post else { return }
        PostController.shared.delete(post: post)
        NotificationCenter.default.post(name: Notification.Name(PostController.feedFetchCompletedNotificationName), object: nil)
        navigationController?.popViewController(animated: true)
    }
  
    // MARK: - Actions
    
    @IBAction func postFollowingButtonTapped(_ sender: UIButton) {
        
        guard let user = UserController.shared.loggedInUser else { return }
        guard let post = self.post else { return }
        
        
        isFollowing = !isFollowing
        
        if isFollowing == true {
            postFollowingButton.setImage(#imageLiteral(resourceName: "star-filled-500"), for: .normal)
            PostController.shared.addFollowerToPost(user: user, post: post)
            
        } else if isFollowing == false {
            postFollowingButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            PostController.shared.removeFollowerFromPost(user: user, post: post)
        }
        updatePostView()
    }
    
    @IBAction func branchPostButtonTapped(_ sender: Any) {
        print("button is working")
        let mySB = UIStoryboard(name: "CreateAndSuggest", bundle: .main)
        let vc = mySB.instantiateViewController(withIdentifier: "CreateAndSuggestSB") as! CreateAndSuggestViewController
        vc.post = self.post
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func commentsButtonTapped(_ sender: Any) {
        print("Trying to show comments")
        print(post?.description as Any)
        let commentsSB = UIStoryboard(name: "Comments", bundle: .main)
        let commentsController = commentsSB.instantiateViewController(withIdentifier: "CommentsSB") as! CommentsTableViewController
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
}
