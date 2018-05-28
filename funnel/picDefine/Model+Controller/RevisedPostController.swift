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

        let revisedPost = RevisedPost(post: post, description: description, category1Ref: category1Ref, category2Ref: category2Ref, category3Ref: category3Ref)
        
        revisedPost.categoryAsString = categoryAsString
        
        ckManager.save(records: [revisedPost.ckRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving new revised post to CloudKit: \(error)")
            }
        }
        
        TagController.shared.saveTagsOnRevisedPost(post: revisedPost, tagString: tagsAsString)
        
    }
    
    func deleteRevisedPost(revisedPost: RevisedPost) {
        if let index = RevisedPostController.shared.revisedPostsToApprove.index(of: revisedPost) {
            RevisedPostController.shared.revisedPostsToApprove.remove(at: index)
        }
        
        if let index = RevisedPostController.shared.revisedPostsUserCreated.index(of: revisedPost) {
            RevisedPostController.shared.revisedPostsUserCreated.remove(at: index)
        }
        
        ckManager.delete(recordID: revisedPost.ckRecordID) { (recordID, error) in
            if let error = error {
                print("Error deleting revised post: \(error)")
                return
            }
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
            
            self.deleteRevisedPost(revisedPost: revisedPost)
            
            completion(true)
        }
    }
    
    func fetchRevisedPostsToApprove(originalPostCreator user: User, completion: @escaping (Bool) -> Void) {
        let userRecordID = user.ckRecordID
        
        let predicate = NSPredicate(format: "creatorRef == %@", userRecordID)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        ckManager.fetch(type: RevisedPost.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
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
            
            let recordsArray = records.compactMap( {RevisedPost(cloudKitRecord: $0) })
            
            self.revisedPostsToApprove = recordsArray
            
            completion(true)
        }
    }
    
}
