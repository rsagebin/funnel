//
//  FeedTableViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, SuggestionDelegate, CommentsDelegate {
    
    // MARK: - Properties
    
    var theRefreshControl: UIRefreshControl!

    // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create refresh control
        theRefreshControl = UIRefreshControl()
        theRefreshControl.addTarget(self, action: #selector(didPullForRefresh), for: .valueChanged)
        tableView.addSubview(theRefreshControl)
        
        // set navigationBar detail
        navigationController?.navigationBar.barTintColor = UIColor(red: 29/255, green: 169/255, blue: 162/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font : UIFont(name: "Arial", size: 20) as Any,
            NSAttributedStringKey.foregroundColor : UIColor.white,
        ]
        
        // fetch posts
        PostController.shared.fetchFeedPosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFeedView), name: NSNotification.Name(PostController.feedFetchCompletedNotificationName), object: nil)
        
        // set cells
        let nib = UINib.init(nibName: "DetailCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DetailCell")
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
    
    
    // MARK: - Other Functions
    
    @objc func didPullForRefresh() {
        
        PostController.shared.fetchFeedPosts()
        tableView.reloadData()
        theRefreshControl.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PostController.shared.feedPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailViewCell
        
        let post = PostController.shared.feedPosts[indexPath.row]
        cell.post = post
        cell.descriptionTextView.isEditable = false
        cell.commentsDelegate = self
        cell.suggestDelegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
    
    // MARK: - Delegate functions
    
    func postSuggestionButtonTapped(post: Post) {
        let submitAndReviewSB = UIStoryboard(name: "CreateAndSuggest", bundle: .main)
        let submitAndReviewVC = submitAndReviewSB.instantiateViewController(withIdentifier: "CreateAndSuggestSB") as! CreateAndSuggestViewController
        submitAndReviewVC.post = post
        navigationController?.pushViewController(submitAndReviewVC, animated: true)
    }
    
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
