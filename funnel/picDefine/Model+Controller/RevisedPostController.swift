//
//  RevisedPostController.swift
//  funnel
//
//  Created by Drew Carver on 5/18/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class RevisedPostController {
    
    let ckManager = CloudKitManager()
    
    static let shared  = RevisedPostController()
    
    var revisedPostsToApprove: [RevisedPost] = []
    var revisedPostsUserCreated: [RevisedPost] = []
    
    func createRevisedPost(for post: Post, description: String, category1: Category1?, category2: Category2?, category3: Category3?, tagsAsString: String) {
        
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

        guard let loggedInUser = UserController.shared.loggedInUser else { return }
        
        let reference = CKReference(recordID: loggedInUser.ckRecordID, action: .none)
        
        let imageAsset = CKAsset(fileURL: post.imageAsCKAsset.fileURL)
        
        let revisedPost = RevisedPost(post: post, description: description, revisedPostCreatorRef: reference, category1Ref: category1Ref, category2Ref: category2Ref, category3Ref: category3Ref, imageCKAsset: imageAsset)
        
        revisedPost.categoryAsString = categoryAsString
        
        ckManager.save(records: [revisedPost.ckRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving new revised post to CloudKit: \(error)")
            }
        }
        
        TagController.shared.saveTagsOnRevisedPost(post: revisedPost, tagString: tagsAsString)
        
    }
    
    func deleteRevisedPost(revisedPost: RevisedPost, completion: @escaping (Bool)-> Void) {
        if let index = RevisedPostController.shared.revisedPostsToApprove.index(of: revisedPost) {
            RevisedPostController.shared.revisedPostsToApprove.remove(at: index)
        }
        
        if let index = RevisedPostController.shared.revisedPostsUserCreated.index(of: revisedPost) {
            RevisedPostController.shared.revisedPostsUserCreated.remove(at: index)
        }
        
        ckManager.delete(recordID: revisedPost.ckRecordID) { (recordID, error) in
            if let error = error {
                print("Error deleting revised post: \(error)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    func acceptRevisedPost(revisedPost: RevisedPost, for post: Post, completion: @escaping (Bool) -> Void) {
        post.description = revisedPost.description
        post.category1Ref = revisedPost.category1Ref
        post.isAnswered = true
        
        ckManager.save(records: [post.ckRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving revised post to CloudKit: \(error)")
                completion(false)
                return
            }
            
            self.deleteRevisedPost(revisedPost: revisedPost, completion: { (success) in
                if !success {
                    print("Error deleting revised post after being accepted.")
                }
            })
            
            completion(true)
        }
    }
    
    func declineRevisedPost(revisedPost: RevisedPost, completion: @escaping (Bool) -> Void) {
        self.deleteRevisedPost(revisedPost: revisedPost, completion: completion)
    }
    
    func fetchNumberOfSuggestionsFor(post: Post, completion: @escaping (Int) -> Void) {
        var suggestionsArray: [RevisedPost] = []
        let predicate = NSPredicate(format: "postReference == %@", post.ckRecordID)
        ckManager.fetch(type: RevisedPost.typeKey, predicate: predicate, sortDescriptor: nil) { (records, error) in
            if let error = error {
                print("Error fetching count of suggestings for post: \(error)")
                completion(0)
                return
            }
            
            guard let records = records else {
                print("Found nil for records fetched from CloudKit.")
                completion(0)
                return
            }
            
            let recordsArray = records.compactMap( {RevisedPost(cloudKitRecord: $0) })
            
            suggestionsArray = recordsArray
            
            completion(suggestionsArray.count)
        }
    }
    
    func fetchPostForRevisedPost(revisedPost: RevisedPost, completion: @escaping (Post?) -> Void) {
        let predicate = NSPredicate(format: "recordID == %@", revisedPost.postReference)
        ckManager.fetch(type: Post.typeKey, predicate: predicate, sortDescriptor: nil) { (records, error) in
            if let error = error {
                print("Error fetching post for revised post: \(error)")
                completion(nil)
                return
            }
            
            guard let records = records?.first else { return }
            
            let post = Post(cloudKitRecord: records)
            
            completion(post)
        }
    }
    
    func fetchRevisedPostsToApprove(originalPostCreator user: User, completion: @escaping (Bool) -> Void) {
        let userRecordID = user.ckRecordID
        
        let predicate = NSPredicate(format: "creatorRef == %@", userRecordID)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        ckManager.fetch(type: RevisedPost.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching revised posts from CloudKit: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else {
                print("Found nil for records fetched from CloudKit.")
                completion(false)
                return
            }
            
            let recordsArray = records.compactMap( {RevisedPost(cloudKitRecord: $0) })
            
            self.revisedPostsToApprove = recordsArray
            
            completion(true)
        }
    }
    
    func fetchRevisedPostsUserCreated(revisedPostCreator user: User, completion: @escaping (Bool) -> Void) {
        let userRecordID = user.ckRecordID
        
        let predicate = NSPredicate(format: "revisedPostCreatorRef == %@", userRecordID)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        ckManager.fetch(type: RevisedPost.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching revised posts from CloudKit: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else {
                print("Found nil for records fetched from CloudKit.")
                completion(false)
                return
            }
            
            let recordsArray = records.compactMap( {RevisedPost(cloudKitRecord: $0) })
            
            self.revisedPostsUserCreated = recordsArray
            
            completion(true)
        }
    }
    
}
