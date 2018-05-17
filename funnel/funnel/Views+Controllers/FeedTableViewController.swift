//
//  FeedTableViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit



class FeedTableViewController: UITableViewController {
    
    // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        return PostController.shared.mockFeedPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedTableViewCell
        
        let post = PostController.shared.mockFeedPosts[indexPath.row]
        cell.post = post
        cell.descriptionTextView.layer.borderColor = UIColor.black.cgColor
        cell.descriptionTextView.layer.borderWidth = 1.0
        cell.commentsTextView.layer.borderColor = UIColor.black.cgColor
        cell.commentsTextView.layer.borderWidth = 1.0
        
        return cell
    }
   
     // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mySB = UIStoryboard(name: "PostDetail", bundle: .main)
        let vc = mySB.instantiateViewController(withIdentifier: "PostDetailSB") as! PostDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedPost = PostController.shared.mockFeedPosts[indexPath.row]
        vc.post = selectedPost
        navigationController?.pushViewController(vc, animated: true)
    }
}
