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
    var userPosts = [Post]()
    
    
    func createPost(description: String, image: UIImage, category: String) -> Post? {
        
        var newPost: Post?
        
        // TODO: Look into a more efficient way to get record ID without having to create a new CK record every time.
        
        // Create CKAsset from image
        
        // Write image to disk as a temprary file in order to create CKAsset
        let imageAsJpeg = UIImageJPEGRepresentation(image, 2.0)
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
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        ckManager.fetch(type: Post.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
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
    
    
    func addCategories(to post: Post, category1: Category1? = nil, category2: Category2? = nil, category3: Category3? = nil) {
        if let category1 = category1 {
            let reference = CKReference(recordID: category1.ckRecordID ?? category1.ckRecord.recordID, action: .none)
            post.category1Ref = reference
        }
        
        if let category2 = category2 {
            guard post.category1Ref != nil || category1 != nil else {
                print("Must have a category 1 before adding category 2.")
                return
            }
            
//            for category in CategoryController.shared.topCategories {
//                if category2.parentRef != category.ckRecordID ?? category.ckRecord.recordID {
//                    print("Category 2 is not contained within a category 1")
//                    return
//                }
//            }
            
            let reference = CKReference(recordID: category2.ckRecordID ?? category2.ckRecord.recordID, action: .none)
            post.category2Ref = reference
        }
        
        if let category3 = category3 {
            guard post.category2Ref != nil || category2 != nil else {
                print("Must have a category 2 before adding category 3.")
                return
            }
            let reference = CKReference(recordID: category3.ckRecordID ?? category3.ckRecord.recordID, action: .none)
            post.category3Ref = reference
        }
        
    }
    
    func addFollowerToPost(user: User, post: Post) {
        let reference = CKReference(recordID: user.ckRecordID ?? user.ckRecord.recordID, action: .none)
        post.followersRefs.append(reference)
        
        ckManager.save(records: [post.ckRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving updated following status to CloudKit: \(error)")
                return
            }
        }
    }
    
    func addTagsTo(tags: [String], post: Post) {
        let postRecordID = post.ckRecordID ?? post.ckRecord.recordID
        let postReference = CKReference(recordID: postRecordID, action: .deleteSelf)
        var tagsRecordArray: [CKRecord] = []
        
        
        for tag in tags {
            let tag = Tag(text: tag, postReference: postReference)
//            post.tags.append(tag)
            tagsRecordArray.append(tag.ckRecord)
        }
        
        ckManager.save(records: tagsRecordArray, perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving tags to CloudKit: \(error)")
                return
            }
        }
        
    }
    
    func fetchFollowingPosts(user: User) {
        let userRecordID = user.ckRecordID ?? user.ckRecord.recordID
        let userReference = CKReference(recordID: userRecordID, action: .deleteSelf)
        
        let predicate = NSPredicate(format: "followersRefs CONTAINS %@", userReference)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        ckManager.fetch(type: Post.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
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

    func fetchUserPosts(user: User, completion: @escaping (Bool) -> Void) {
        let userRecordID = user.ckRecordID ?? user.ckRecord.recordID
        
        let predicate = NSPredicate(format: "creatorRef == %@", userRecordID)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        ckManager.fetch(type: Post.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
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
