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
    
    
    func createPost(user: User, description: String, image: UIImage, category: String) {
        let creatorReference = CKReference(recordID: user.ckRecord.recordID, action: .deleteSelf)
        let post = Post(user: user, description: description, image: image, category: category, creatorRef: creatorReference)
        
        ckManager.save(records: [post.ckRecord], perRecordCompletion: nil) { (record, error) in
            if let error = error {
                print("Error saving user to CloudKit: \(error)")
                return
            }
        }
    }
    
    func fetchFeedPosts() {
        
        let predicate = NSPredicate(value: true)
        
        ckManager.fetch(type: Post.typeKey, predicate: predicate) { (records, error) in
            if let error = error {
                print("Error fetching posts from CloudKit: \(error.localizedDescription)")
                return
            }
            
            guard let records = records else {
                print("Found nil for records fetched from CloudKit.")
                return
            }
            
            let recordsArray = records.compactMap( {Post(cloudKitRecord: $0) })
        }
    }
    
    func fetchUserPosts() {
        
    }
    
    func setUpMockData() {
        
        var userAppleIDReference: CKReference?
        
        ckManager.getUserRecordID { (recordID, error) in
            if let error = error {
                print("Error getting user's Apple ID: \(error)")
                return
            }
            
            guard let recordID = recordID else { return }
            
            userAppleIDReference = CKReference(recordID: recordID, action: .deleteSelf)
            
            guard let reference = userAppleIDReference else { return }
            
            let user = User(username: "testing", name: "test2", appleUserRef: reference)
            let post = Post(user: user, description: "Image description.", image: UIImage(named: "settings")!, category: "Test category", creatorRef: CKReference(record: user.ckRecord, action: .deleteSelf))
            
            let posts = [post]
            
            self.posts = posts
            
        
        }
        


    }
    
    init() {
        // No thouchy
        
        let user = User(username: "testing", name: "test2", appleUserRef: nil)
        let post = Post(user: user, description: "Image description.", image: UIImage(named: "settings")!, category: "Test category", creatorRef: CKReference(record: user.ckRecord, action: .deleteSelf))
        let post2 = Post(user: user, description: "Image description 2.", image: UIImage(named: "settings")!, category: "Test category", creatorRef: CKReference(record: user.ckRecord, action: .deleteSelf))

        self.mockFeedPosts = [post, post2]
    
        
        setUpMockData()
    }
    
}
