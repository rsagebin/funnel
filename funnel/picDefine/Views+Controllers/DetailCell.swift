//
//  FeedTableViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class DetailCell: UITableViewController, /*SuggestionDelegate,*/ CommentsDelegate {
    
    
    
    // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 29/255, green: 169/255, blue: 162/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font : UIFont(name: "Arial", size: 20) as Any,
            NSAttributedStringKey.foregroundColor : UIColor.white,
        ]
        PostController.shared.fetchFeedPosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFeedView), name: NSNotification.Name(PostController.feedFetchCompletedNotificationName), object: nil)
    }
    
    @objc func reloadFeedView() {
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PostController.shared.feedPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("DetailCell", owner: self, options: nil)?.first as! FeedTableViewCell
        
        let post = PostController.shared.feedPosts[indexPath.row]
        cell.post = post
//        cell.descriptionTextView.layer.borderColor = UIColor.black.cgColor
//        cell.descriptionTextView.layer.borderWidth = 1.0
//        cell.tagsTextView.layer.borderColor = UIColor.black.cgColor
//        cell.tagsTextView.layer.borderWidth = 1.0
        cell.descriptionTextView.isEditable = false
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
    
    // MARK: - Delegate functions
    
//    func postSuggestionButtonTapped(post: Post) {
//        let submitAndReviewSB = UIStoryboard(name: "SubmitAndReview", bundle: .main)
//        let submitAndReviewVC = submitAndReviewSB.instantiateViewController(withIdentifier: "PostAndSubmitSB") as! CreateAndSuggestViewController
//        submitAndReviewVC.post = post
//        navigationController?.pushViewController(submitAndReviewVC, animated: true)
//    }
    
    func didTapComment(post: Post) {
        print("Message coming from FeedController")
        print(post.description)
        let commentsSB = UIStoryboard(name: "Comments", bundle: .main)
        let commentsController = commentsSB.instantiateViewController(withIdentifier: "CommentsSB") as! CommentsTableViewController
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
   
    
     // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mySB = UIStoryboard(name: "PostDetail", bundle: .main)
        let vc = mySB.instantiateViewController(withIdentifier: "PostDetailSB") as! PostDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedPost = PostController.shared.feedPosts[indexPath.row]
        vc.post = selectedPost
        navigationController?.pushViewController(vc, animated: true)
    }
}
