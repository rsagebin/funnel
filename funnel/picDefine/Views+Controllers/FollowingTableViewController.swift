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
    var sectionTitles: [String] = ["My Posts", "Posts I'm Following", "Posts to Revise", "My Suggested Posts"]
//    var refreshControl: UIRefreshControl!
    var userPosts = [Post]()
    var userFollowings = [Post]()
    var communitySuggestions = [RevisedPost]()
    var userSuggestions = [RevisedPost]()
    
    var allPosts: [[Any]] {
        return [userPosts, userFollowings, communitySuggestions, userSuggestions]
    }
//    var revisedPost: RevisedPost? move back to PostDetail

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
        fetchUserSuggestionPosts()
        fetchSuggestionsToApprove()
    }
    
    
    // MARK: - TableView Methods
    // Sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 0
        
        if userPosts.count > 0 {
            sectionCount += 1
        }
        
        if userFollowings.count > 0 {
            sectionCount += 1
        }
        
        if communitySuggestions.count > 0 {
            sectionCount += 1
        }
        
        if userSuggestions.count > 0 {
            sectionCount += 1
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
        let rows = allPosts[section].count
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? FollowingTableViewCell else { return UITableViewCell() }
        
//        let userPosts = self.allPosts[indexPath.section][indexPath.row]
//
//
//        if allPosts[indexPath.section] ==
        
        if indexPath.section == 0 {
            let post = userPosts[indexPath.row]
            cell.userPost = post
            return cell
        }

        if indexPath.section == 1 {
            let following = userFollowings[indexPath.row]
            cell.userFollowing = following
            return cell
        }

        if indexPath.section == 2 {
            let suggestion = communitySuggestions[indexPath.row]
            cell.communitySuggestion = suggestion
            return cell
        }

        if indexPath.section == 3 {
            let suggestion = userSuggestions[indexPath.row]
            cell.userSuggestion = suggestion
            return cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let selectedPost = self.allPosts[indexPath.section][indexPath.row]
        
        if let selectedPost = selectedPost as? Post {
            
            let postDetailSB = UIStoryboard(name: "PostDetail", bundle: .main)
            let postDetailVC = postDetailSB.instantiateViewController(withIdentifier: "PostDetailSB") as! PostDetailViewController
            postDetailVC.post = selectedPost
            navigationController?.pushViewController(postDetailVC, animated: true)
        }
        
        if let selectedPost = selectedPost as? RevisedPost {
            
            let createAndSuggestSB = UIStoryboard(name: "CreateAndSuggest", bundle: .main)
            let createAndSuggestVC = createAndSuggestSB.instantiateViewController(withIdentifier: "CreateAndSuggestSB") as! CreateAndSuggestViewController
            createAndSuggestVC.revisedPost = selectedPost
            navigationController?.pushViewController(createAndSuggestVC, animated: true)
        }
    }
    
    func fetchUserPosts() {
        
        startNetworkActivity()
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        PostController.shared.fetchUserPosts(user: user) { (success) in
            DispatchQueue.main.async {
                
                if success {
                    self.userPosts = PostController.shared.userPosts
                    self.endNetworkActivity()
                    self.tableView.reloadData()
                }
                
                if !success {
                    print("Could not fetch user posts")
                    self.endNetworkActivity()
                }
            }
        }
    }
    
    func fetchFollowingPosts() {
        
        startNetworkActivity()
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        PostController.shared.fetchFollowingPosts(user: user) { (success) in
            DispatchQueue.main.async {
                
                if success {
                    self.userFollowings = PostController.shared.followingPosts
                    self.endNetworkActivity()
                    self.tableView.reloadData()
                }
                
                if !success {
                    print("Could not fetch following posts")
                    self.endNetworkActivity()
                }
            }
        }
    }
    
    func fetchSuggestionsToApprove() {
        
        startNetworkActivity()
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        RevisedPostController.shared.fetchRevisedPostsToApprove(originalPostCreator: user) { (success) in
            DispatchQueue.main.async {
                
                if success {
                    self.communitySuggestions = RevisedPostController.shared.revisedPostsToApprove
                    self.endNetworkActivity()
                    self.tableView.reloadData()
                }
                
                if !success {
                    print("Could not fetch community suggested posts")
                }
            }
        }
    }
    
    func fetchUserSuggestionPosts() {
        
        startNetworkActivity()
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        RevisedPostController.shared.fetchRevisedPostsUserCreated(revisedPostCreator: user) { (success) in
            DispatchQueue.main.async {
                
                if success {
                    self.userSuggestions = RevisedPostController.shared.revisedPostsUserCreated
                    self.endNetworkActivity()
                    self.tableView.reloadData()
                }
                
                if !success {
                    print("Could not fetch user suggested posts")
                    self.endNetworkActivity()
                }
            }
        }
    }
    
    func startNetworkActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func endNetworkActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
