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
    
    static let shared = PostController()
    
    var feedPosts = [Post]()
    var followingPosts = [Post]()
    var userPosts = [Post]()
    
    var category1Posts = [Post]()
    var category2Posts = [Post]()
    var category3Posts = [Post]()

    func createPost(description: String, image: UIImage, category1: Category1?, category2: Category2?, category3: Category3?, tagString: String) {
        
        // Create CKAsset from image
        // Write image to disk as a temprary file in order to create CKAsset
        let imageAsJpeg = UIImageJPEGRepresentation(image, 0.5)
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
    
        do {
            try imageAsJpeg?.write(to: url)
        } catch {
            print("Couldn't write temporary image to file: \(error)")
            return
        }
        
        let asset = CKAsset(fileURL: url)
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        let creatorReference = CKReference(recordID: user.ckRecordID, action: .deleteSelf)
        
        var categoryAsString = ""
        
        var category1Ref: CKReference?
        var category2Ref: CKReference?
        var category3Ref: CKReference?
        
        if let category1 = category1 {
            category1Ref = CKReference(recordID: category1.ckRecordID, action: .none)
            categoryAsString += category1.title
        }
        
        if let category2 = category2 {
            category2Ref = CKReference(recordID: category2.ckRecordID, action: .none)
            categoryAsString += "\\" + "\(category2.title)"
        }
        
        if let category3 = category3 {
            category3Ref = CKReference(recordID: category3.ckRecordID, action: .none)
            categoryAsString += "\\" + "\(category3.title)"
        }
        
        let post = Post(user: user, description: description, imageAsCKAsset: asset, creatorRef: creatorReference, category1Ref: category1Ref, category2Ref: category2Ref, category3Ref: category3Ref)
        
        post.categoryAsString = categoryAsString
        
        self.feedPosts.insert(post, at: 0)
        
        CloudKitManager.shared.save(records: [post.ckRecord], perRecordCompletion: nil) { (record, error) in
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
        
        TagController.shared.saveTagsOnPost(post: post, tagString: tagString)

    }
    
    func delete(post: Post) {
        if let index = PostController.shared.feedPosts.index(of: post) {
            PostController.shared.feedPosts.remove(at: index)
        }
        
        if let index = PostController.shared.followingPosts.index(of: post) {
            PostController.shared.followingPosts.remove(at: index)
        }
        
        CloudKitManager.shared.delete(recordID: post.ckRecordID) { (recordID, error) in
            if let error = error {
                print("Error deleting record from CloudKit: \(error)")
            }
        }
    }
    
    func fetchFeedPosts(completion: @escaping (Bool) -> Void) {
        self.feedPosts = []
        
        guard let loggedInUser = UserController.shared.loggedInUser else {
            completion(false)
            return
        }
        
        let predicate = NSPredicate(format: "NOT (creatorRef IN %@)", loggedInUser.blockedUsers)

        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        CloudKitManager.shared.fetch(type: Post.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching posts from CloudKit: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else {
                print("Found nil for records fetched from CloudKit.")
                completion(false)
                return
            }
            
            let recordsArray = records.compactMap( {Post(cloudKitRecord: $0)})
            
            self.feedPosts = recordsArray
            
            NotificationCenter.default.post(name: NSNotification.Name(PostController.feedFetchCompletedNotificationName), object: self)
            
            completion(true)
        }
    }
    
    
    func fetchPostsFor(category1: Category1, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "category1Ref == %@", category1.ckRecordID)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        CloudKitManager.shared.fetch(type: Post.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching posts for category 1: \(error)")
                completion(false)
                return
            }
            
            guard let posts = records?.compactMap({ Post(cloudKitRecord: $0) }) else {
                completion(false)
                return
            }
            
            self.category1Posts = posts
            
            completion(true)
        }
    }
    
    func fetchPostsFor(category2: Category2, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "category2Ref == %@", category2.ckRecordID)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        CloudKitManager.shared.fetch(type: Post.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching posts for category 2: \(error)")
                completion(false)
                return
            }
            
            guard let posts = records?.compactMap({ Post(cloudKitRecord: $0) }) else {
                completion(false)
                return
            }
            
            self.category2Posts = posts
            
            completion(true)
        }
    }
    
    func fetchPostsFor(category3: Category3, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "category3Ref == %@", category3.ckRecordID)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        CloudKitManager.shared.fetch(type: Post.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching posts for category 3: \(error)")
                completion(false)
                return
            }
            
            guard let posts = records?.compactMap({ Post(cloudKitRecord: $0) }) else {
                completion(false)
                return
            }
            
            self.category3Posts = posts
            
            completion(true)
        }
    }
    
    func addCategories(to post: Post, category1: Category1? = nil, category2: Category2? = nil, category3: Category3? = nil) {
        if let category1 = category1 {
            let reference = CKReference(recordID: category1.ckRecordID, action: .none)
            post.category1Ref = reference
        }
        
        if let category2 = category2 {
            guard post.category1Ref != nil || category1 != nil else {
                print("Must have a category 1 before adding category 2.")
                return
            }
            
            let reference = CKReference(recordID: category2.ckRecordID, action: .none)
            post.category2Ref = reference
        }
        
        if let category3 = category3 {
            guard post.category2Ref != nil || category2 != nil else {
                print("Must have a category 2 before adding category 3.")
                return
            }
            let reference = CKReference(recordID: category3.ckRecordID, action: .none)
            post.category3Ref = reference
        }
        
    }
    
    func addFollowerToPost(user: User, post: Post) {
        let reference = CKReference(recordID: user.ckRecordID, action: .none)
        post.followersRefs.append(reference)
        
        CloudKitManager.shared.save(records: [post.ckRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving updated following status to CloudKit: \(error)")
                return
            }
        }
    }
    
    func removeFollowerFromPost(user: User, post: Post) {
        let reference = CKReference(recordID: user.ckRecordID, action: .none)
        guard let index = post.followersRefs.index(of: reference) else { return }
        post.followersRefs.remove(at: index)
        CloudKitManager.shared.save(records: [post.ckRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error remove follower from post: \(error)")
                return
            }
        }
    }
    
    
    func fetchFollowingPosts(user: User, completion: @escaping (Bool) -> Void) {
        let userRecordID = user.ckRecordID
        let userReference = CKReference(recordID: userRecordID, action: .deleteSelf)
        
        let predicate = NSPredicate(format: "followersRefs CONTAINS %@", userReference)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        CloudKitManager.shared.fetch(type: Post.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching posts from CloudKit: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else {
                print("Found nil for records fetched from CloudKit.")
                completion(false)
                return
            }
            
            let recordsArray = records.compactMap( {Post(cloudKitRecord: $0) })
            
            self.followingPosts = recordsArray
            
            completion(true)
        }
    }

    func flag(post: Post, completion: @escaping (Bool, Bool) -> Void) {
        
        // Only increment if user hasn't already flagged the post
        guard let currentUserRef = UserController.shared.loggedInUser else { return }
        
        let reference = CKReference(recordID: currentUserRef.ckRecordID, action: .none)
        
        if post.flaggingUsersRefs.contains(reference) {
            return completion(false, true)
        }
        
        post.numberOfFlags += 1
        
        if post.numberOfFlags > 2 {
            self.delete(post: post)
        } else {
            post.flaggingUsersRefs.append(reference)
            CloudKitManager.shared.save(records: [post.ckRecord], perRecordCompletion: nil) { (records, error) in
                if let error = error {
                    print("Error saving post after adding flag: \(error)")
                    completion(false, false)
                }
                
                completion(true, false)
            }
        }
    }
    
    func fetchUserPosts(user: User, completion: @escaping (Bool) -> Void) {
        let userRecordID = user.ckRecordID
        
        let predicate = NSPredicate(format: "creatorRef == %@", userRecordID)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        CloudKitManager.shared.fetch(type: Post.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching posts from CloudKit: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else {
                print("Found nil for records fetched from CloudKit.")
                completion(false)
                return
            }
            
            let recordsArray = records.compactMap( {Post(cloudKitRecord: $0) })
            
            self.userPosts = recordsArray
            
            completion(true)
        }
    }
    

    func subscribeToPushNotifications(completion: @escaping ((CKSubscription?, Error?) -> Void)) {
        CloudKitManager.shared.subscribeTo(CloudKitKeys.type, completion: completion)
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
