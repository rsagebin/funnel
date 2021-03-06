//
//  CommentController.swift
//  funnel
//
//  Created by Drew Carver on 5/16/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit


class CommentController {
    
    var postComments: [Comment] = []
    
    static let shared = CommentController()
    
    func addCommentTo(post: Post, text: String, completion: @escaping (Bool) -> Void) {
        guard let user = UserController.shared.loggedInUser else { return }
        
        let postReference = CKReference(recordID: post.ckRecordID, action: .deleteSelf)
        
        let userReference = CKReference(recordID: user.ckRecordID, action: .deleteSelf)
        
        let comment = Comment(post: post, text: text, user: user, postReference: postReference, userReference: userReference)
        
        CloudKitManager.shared.save(records: [comment.ckRecord], perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print("Error saving comment to CloudKit: \(error)")
                completion(false)
                return
            }
            
            self.postComments.append(comment)
            completion(true)
        }
        
    }
    
    func loadCommentCountFor(post: Post, completion: @escaping (Bool, Int) -> Void) {
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        let predicate = NSPredicate(format: "postReference == %@ && NOT (userReference IN %@)", post.ckRecordID, user.blockedUsers)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        
        CloudKitManager.shared.fetch(type: Comment.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error loading comments for post: \(error)")
                completion(false, 0)
                return
            }
            
            guard let commentsArray = records?.compactMap({Comment(cloudKitRecord: $0)}) else { return }
            
            completion(true, commentsArray.count)
        }
        
    }
    
    func loadCommentsFor(post: Post, completion: @escaping (Bool) -> Void) {
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        let predicate = NSPredicate(format: "postReference == %@ && NOT (userReference IN %@)", post.ckRecordID, user.blockedUsers)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        
        CloudKitManager.shared.fetch(type: Comment.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error loading comments for post: \(error)")
                completion(false)
                return
            }
            
            guard let commentsArray = records?.compactMap({Comment(cloudKitRecord: $0)}) else { return }
            self.postComments = commentsArray
            completion(true)
        }
        
    }
    
    func loadUserFor(comment: Comment, completion: @escaping (User?) -> Void) {
        
        let predicate = NSPredicate(format: "recordID == %@", comment.userReference)
        
        CloudKitManager.shared.fetch(type: User.typeKey, predicate: predicate, sortDescriptor: nil) { (records, error) in
            if let error = error {
                print("Error fetching user for comment:\(error)")
                completion(nil)
                return
            }
            
            guard let record = records?.first else { return }
            
            let fetchedUser = User(cloudKitRecord: record)
            
            completion(fetchedUser)

        }

    }
    
    func deleteComment(commentID: CKRecordID, completion: @escaping (Bool) -> Void) {
        CloudKitManager.shared.delete(recordID: commentID) { (recordID, error) in
            if let error = error {
                print("Error deleting comment from CloudKit: \(error)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
}
