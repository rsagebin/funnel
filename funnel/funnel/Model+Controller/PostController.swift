//
//  PostController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class PostController {
    
    static let shared = PostController()
    
    // Possibly have two collections of posts - Feed and Following.
    // Possibly use NSPredicate in CKManager to specific time frame, etc. Or implement infinite scroll.
    
    // Use notification center to notifiy feed view/following view when posts have been loaded to refresh the tableview
    
//    var user = User(username: "testing", name: "Test Test")
//
//    lazy var posts = [Post(user: user, description: "Test Post Description", imageURL: URL(string: "http://www.google.com/")!)]
    
    var posts = [Post]()
    
    let ckManager = CloudKitManager()
    
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
    
}
