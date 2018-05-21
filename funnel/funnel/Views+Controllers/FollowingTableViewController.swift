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
    var userPosts = [Post]()
    var userSuggestions = [Post]()
    var userFollowings = [Post]()
//    let userContent = [[self.userPosts], [self.userSuggestions], [self.userFollowings]]
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Following" // Isn't reflecting on the bar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = UserController.shared.loggedInUser else { return }
        PostController.shared.fetchUserPosts(user: user) { (success) in
            DispatchQueue.main.async {
                
                if success {
                    self.userPosts = PostController.shared.followingPosts // Update to userPosts before push
                    self.tableView.reloadData()
                }
                
                if !success {
                    print("Could not fetch user posts")
                }
            }
        }
    }
    
    
    // MARK: - TableView Methods
    // Sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 0
        
        let posts = userPosts.count // Change to 1 from 0 if user has any posts
        if posts > 0 {
            sectionCount += 1
            sectionTitles.append("My Posts")
        }
        
        let submittedAnswers = 0 // Change to 1 from 0 if user has any suggested answers
        if submittedAnswers > 0 {
            sectionCount += 1
            sectionTitles.append("My Suggested Answers")
        }
        
        let followingPosts = 0 // Change to 1 from 0 if user is following posts
        if followingPosts > 0 {
            sectionCount += 1
            sectionTitles.append("Posts I'm Following")
        }
        
        let commentedOn = 0 // Change to 1 if user has any comments // Maybe impliment later on
        if commentedOn > 0 {
            sectionCount += 1
            sectionTitles.append("Posts I have commented on")
        }
        
        return sectionCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard sectionTitles.indices ~= section else { return nil }
        return sectionTitles[section]
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        <#code#>
//    }
    
    // Rows
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight = 115
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136: cellHeight = 115; print("5, 5S, 5C, SE")
            case 1334: cellHeight = 122; print("6, 6S, 7, 8")
            case 2208: cellHeight = 125; print("6+, 6S+, 7+, 8+")
            case 2436: cellHeight = 122; print("X")
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
        
//        if section == 1 { // User submissions
//
//        }
//
        if section == 2 { // User followings
            let followings = userFollowings.count
            return followings
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? FollowingTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let post = userPosts[indexPath.row]
            cell.userPost = post
        }
        
//        let suggestions = PostController.shared
//        if indexPath.section == 1 {
//            cell.userSuggestion =
//        }
        
        
        if indexPath.section == 2 {
            let following = userFollowings[indexPath.row]
            cell.userFollowing = following
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postDetailSB = UIStoryboard(name: "PostDetail", bundle: .main)
        let currentVC = postDetailSB.instantiateViewController(withIdentifier: "PostDetailSB") as! PostDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedPost = PostController.shared.feedPosts[indexPath.row]
        
        currentVC.post = selectedPost
        navigationController?.pushViewController(currentVC, animated: true)
    }
}
