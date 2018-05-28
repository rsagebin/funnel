//
//  PersonalFeedViewController.swift
//  funnel
//
//  Created by Alec Osborne on 5/14/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class FollowingTableViewController: UITableViewController {

    // MARK: - Properties
    var sectionTitles: [String] = []
//    var refreshControl: UIRefreshControl!
    var userPosts = [Post]()
    var userSuggestions = [RevisedPost]()
    var userFollowings = [Post]()
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Following" // Isn't reflecting on the bar
//        createRefreshControl()
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136: print("5, 5S, 5C, SE")
            case 1334: print("6, 6S, 7, 8")
            case 2208: print("6+, 6S+, 7+, 8+")
            case 2436: print("X")
            default: print("Unknown Device Height \(#function)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserPosts()
        fetchFollowingPosts()
    }
    
    
    // MARK: - TableView Methods
    // Sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 0
        
        let posts = userPosts.count
        if posts > 0 {
            sectionCount += 1
            sectionTitles.append("My Posts")
            
            if sectionTitles == ["My Posts","My Posts"] { // Patch to remove duplicate refactor later
                sectionTitles.remove(at: 0)
            }
        }
        
        let followings = userFollowings.count
        if followings > 0 {
            sectionCount += 1
            sectionTitles.append("Posts I'm Following")
            
            if sectionTitles == ["Posts I'm Following","Posts I'm Following"] { // Patch to remove duplicate refactor later
                sectionTitles.remove(at: 0)
            }
        }
        
        let submittedAnswers = 0 // Change to 1 from 0 if user has any suggested answers
        if submittedAnswers > 0 {
            sectionCount += 1
            sectionTitles.append("My Suggested Answers")
            
            if sectionTitles == ["My Suggested Answers","My Suggested Answers"] { // Patch to remove duplicate refactor later
                sectionTitles.remove(at: 0)
            }
        }
        
        let commentedOn = 0 // Change to 1 if user has any comments // Maybe impliment later on
        if commentedOn > 0 {
            sectionCount += 1
            sectionTitles.append("Posts I have commented on")
            
            if sectionTitles == ["Posts I have commented on","Posts I have commented on"] { // Patch to remove duplicate refactor later
                sectionTitles.remove(at: 0)
            }
        }
        
        return sectionCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sectionTitles.indices ~= section else { return nil }
        return sectionTitles[section]
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
    // Rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight = 115
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136: cellHeight = 115
            case 1334: cellHeight = 122
            case 2208: cellHeight = 125
            case 2436: cellHeight = 122
            default: print("Unknown Device Height \(#function)")
            }
        }
        return CGFloat(cellHeight)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { // User posts
            let posts = userPosts.count
            return posts
        }

        if section == 1 { // User followings
            let followings = userFollowings.count
            return followings
        }
        
        if section == 2 { // User submissions
            
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? FollowingTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let post = userPosts[indexPath.row]
            cell.userPost = post
        }
        
        if indexPath.section == 1 {
            let following = userFollowings[indexPath.row]
            cell.userFollowing = following
        }
        
//        let suggestions = PostController.shared
        if indexPath.section == 2 {
//            cell.userSuggestion =
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postDetailSB = UIStoryboard(name: "PostDetail", bundle: .main)
        let currentVC = postDetailSB.instantiateViewController(withIdentifier: "PostDetailSB") as! PostDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedPost = PostController.shared.userPosts[indexPath.row]
        
        currentVC.post = selectedPost
        navigationController?.pushViewController(currentVC, animated: true)
    }
    
    func fetchUserPosts() {
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        PostController.shared.fetchUserPosts(user: user) { (success) in
            DispatchQueue.main.async {
                
                if success {
                    self.userPosts = PostController.shared.userPosts
                    self.tableView.reloadData()
                }
                
                if !success {
                    print("Could not fetch user posts")
                }
            }
        }
    }
    
    func fetchFollowingPosts() {
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        PostController.shared.fetchFollowingPosts(user: user) { (success) in
            DispatchQueue.main.async {
                
                if success {
                    self.userFollowings = PostController.shared.followingPosts
                    self.tableView.reloadData()
                }
                
                if !success {
                    print("Could not fetch following posts")
                }
            }
        }
    }
    
    func fetchSuggestionPosts() {
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        RevisedPostController.shared.fetchRevisedPostsToApprove(originalPostCreator: user) { (success) in
            DispatchQueue.main.async {
                
                if success {
                    self.userSuggestions = RevisedPostController.shared.revisedPostsToApprove
                    self.tableView.reloadData()
                }
                
                if !success {
                    print("Could not fetch suggested posts")
                }
            }
        }
    }
    
//    func createRefreshControl() {
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(didPullForRefresh), for: .valueChanged)
//        tableView.addSubview(refreshControl)
//    }
//    
//    @objc func didPullForRefresh() {
//        self.fetchUserPosts()
//        self.fetchFollowingPosts()
//        self.fetchSuggestionPosts()
//        refreshControl.endRefreshing()
//    }
}
