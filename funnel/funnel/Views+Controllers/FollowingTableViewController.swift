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
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.title = "Following"
    }
    
    
    // MARK: - TableView Methods
    // Sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 0
        
        let userPosts = 1 // Change to 1 from 0 if user has any posts
        if userPosts > 0 {
            sectionTitles.append("My Posts")
            sectionCount += 1
        }
        
        let suggestedAnswers = 1 // Change to 1 from 0 if user has any suggested answers
        if suggestedAnswers > 0 {
            sectionCount += 1
            sectionTitles.append("My Suggested Answers")
        }
        
        let followingPosts = 1 // Change to 1 from 0 if user is following posts
        if followingPosts > 0 {
            sectionCount += 1
            sectionTitles.append("Posts I'm Following")
        }
        
        let commentedOn = 1 // Change to 1 from 0 if user has any comments
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        return cell
    }
    
    
    /*
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
