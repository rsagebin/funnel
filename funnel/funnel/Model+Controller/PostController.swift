//
//  PostController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

class PostController {

    let ckManager = CloudKitManager()
    
    static let shared = PostController()
    
    // Possibly have two collections of posts - Feed and Following.
    // Possibly use NSPredicate in CKManager to specific time frame, etc. Or implement infinite scroll.
    
    // Use notification center to notifiy feed view/following view when posts have been loaded to refresh the tableview
    
    // No thouchy
    var mockFeedPosts: [Post] = []
    
    var posts = [Post]()
    
    
    func savePost() {
        let postsCKRecords = posts.map { $0.ckRecord }
        ckManager.save(records: postsCKRecords, perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving records to CloudKit: \(error.localizedDescription)")
                return
            } else {
                print("Successfully saved records to CloudKit.")
            }
        }
    }
    
    func fetchPosts() {
        ckManager.fetchRecordsWith(type: Post.typeKey) { (records, error) in
            if let error = error {
                print("Error fetching posts from CloudKit: \(error.localizedDescription)")
                return
            }
            
            guard let records = records else {
                print("Found nil for records fetched from CloudKit.")
                return
            }
            
            let posts = records.compactMap({ Post(cloudKitRecord: $0) })
            
            self.posts = posts
        }
    }
    
    func fetchUserPosts() {
        
    }
    
    func setUpMockData() {
        
        var userAppleIDReference: CKReference?
        
        ckManager.getUserReference { (recordID, error) in
            if let error = error {
                print("Error getting user's Apple ID: \(error)")
                return
            }
            
            guard let recordID = recordID else { return }
            
            userAppleIDReference = CKReference(recordID: recordID, action: .deleteSelf)
            
        }
        
        guard let reference = userAppleIDReference else { return }
        
        let user = User(username: "testing", name: "test2", userRef: reference)
        let post = Post(user: user, description: "Image description.", image: UIImage(named: "settings")!, creatorRef: CKReference(record: user.ckRecord, action: .deleteSelf))
        
        
        let posts = [post]
        
        self.posts = posts
    }
    
    init() {
        // No thouchy
        let user = User(username: "testing", name: "test2", userRef: nil)
        let post = Post(user: user, description: "Image description.", image: UIImage(named: "settings")!, creatorRef: CKReference(record: user.ckRecord, action: .deleteSelf))
        let post2 = Post(user: user, description: "Image description 2.", image: UIImage(named: "settings")!, creatorRef: CKReference(record: user.ckRecord, action: .deleteSelf))

        self.mockFeedPosts = [post, post2]
    
        
        setUpMockData()
        savePost()
    }
    
}
