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

    static let feedFetchCompletedNotificationName = "feedFetchCompleted"
    
    let ckManager = CloudKitManager()
    
    static let shared = PostController()
    
    // Possibly use NSPredicate in CKManager to specific time frame, etc. Or implement infinite scroll.
    
    // No touchy - mock data
    var mockFeedPosts: [MockPost] = []
    
    var feedPosts = [Post]()
    var followingPosts = [Post]()
    var myPosts = [Post]()
    
    
    func createPost(description: String, image: UIImage, category: String) -> Post? {
        
        var newPost: Post?
        
        // TODO: Look into a more efficient way to get record ID without having to create a new CK record every time.
        
        // Create CKAsset from image
        
        // Write image to disk as a temprary file in order to create CKAsset
        let imageAsJpeg = UIImageJPEGRepresentation(image, 5.0)
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
    
        do {
            try imageAsJpeg?.write(to: url)
        } catch {
            print("Couldn't write temporary image to file: \(error)")
            return nil
        }
        
        let asset = CKAsset(fileURL: url)
        
        guard let user = UserController.shared.loggedInUser else { return nil }
        
        let creatorReference = CKReference(recordID: user.ckRecordID ?? user.ckRecord.recordID, action: .deleteSelf)
        let post = Post(user: user, description: description, imageAsCKAsset: asset, category: category, creatorRef: creatorReference)
        
        post.followersRefs.append(creatorReference)
        
        newPost = post
        
        self.feedPosts.insert(post, at: 0)
        
        ckManager.save(records: [post.ckRecord], perRecordCompletion: nil) { (record, error) in
            if let error = error {
                print("Error saving post to CloudKit: \(error)")
                return
            }
            
            // Delete temporary image after creating CKAsset and saving new post
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("Error deleting temporary image file: \(error)")
                return
            }
        }
        
        fetchFollowingPosts(user: user)
        
        return newPost
        
    }
    
    
    func fetchFeedPosts() {
        
        self.feedPosts = []
        
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
            
            let recordsArray = records.compactMap( {Post(cloudKitRecord: $0)})
            
            self.feedPosts = recordsArray
            
            NotificationCenter.default.post(name: NSNotification.Name(PostController.feedFetchCompletedNotificationName), object: self)
        }
    }
    
    func addFollowerToPost(user: User, post: Post) {
        let reference = CKReference(recordID: user.ckRecordID ?? user.ckRecord.recordID, action: .none)
        post.followersRefs.append(reference)
        
        ckManager.save(records: [post.ckRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving updated following status to CloudKit: \(error)")
            }
        }
    }
    
    func fetchFollowingPosts(user: User) {
        
        // FIXME: This predicate needs to be updated to only pull posts that the person is following
        let userRecordID = user.ckRecordID ?? user.ckRecord.recordID
        let userReference = CKReference(recordID: userRecordID, action: .deleteSelf)
        
        let predicate = NSPredicate(format: "followersRefs CONTAINS %@", userReference)
        
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
            
            self.myPosts = recordsArray
        }
    }

    func fetchMyPosts(user: User) {
        
        // FIXME: This predicate needs to be updated to only pull posts that the person is following
        let userRecordID = user.ckRecordID ?? user.ckRecord.recordID
        
        let predicate = NSPredicate(format: "creatorRef == %@", userRecordID)
        
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
            
            self.followingPosts = recordsArray
        }
    }
    
    
    
    init() {    

    }
    
}

extension UIImage {
    convenience init?(ckAsset: CKAsset) {
        var imageData = Data()
        
        do {
            let data = try Data(contentsOf: ckAsset.fileURL)
            imageData = data
        } catch {
            print("Error re-creating data from CKAsset: \(error)")
        }
        
        self.init(data: imageData)
    }
}
