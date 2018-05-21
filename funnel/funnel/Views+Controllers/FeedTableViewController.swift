//
//  FeedTableViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, CommentsDelegate {
    
    // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostController.shared.fetchFeedPosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFeedView), name: NSNotification.Name(PostController.feedFetchCompletedNotificationName), object: nil)
    }
    
    @objc func reloadFeedView() {
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PostController.shared.feedPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedTableViewCell
        
        let post = PostController.shared.feedPosts[indexPath.row]
        cell.post = post
        cell.descriptionTextView.layer.borderColor = UIColor.black.cgColor
        cell.descriptionTextView.layer.borderWidth = 1.0
        cell.tagsTextView.layer.borderColor = UIColor.black.cgColor
        cell.tagsTextView.layer.borderWidth = 1.0
        
        cell.delegate = self
        
        return cell
    }
    
    
    // MARK: - Delegate functions
    
    func didTapComment(post: Post) {
        print("Massaeg coming from FeedController")
        print(post.description)
        let commentasSB = UIStoryboard(name: "Comments", bundle: .main)
        let commentsController = commentasSB.instantiateViewController(withIdentifier: "CommentsSB") as! CommentsTableViewController
        
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
    
    
    // MARK: - Actions
    @IBAction func postFollowButtonPressed(_ sender: UIButton) {
        
    }
}
