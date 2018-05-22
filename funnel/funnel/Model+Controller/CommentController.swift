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
    
    let ckManager = CloudKitManager()
    
    static let shared = CommentController()
    
    func addCommentTo(post: Post, text: String, completion: @escaping (Bool) -> Void) {
        guard let user = UserController.shared.loggedInUser else { return }
        
        let postReference = CKReference(recordID: post.ckRecordID ?? post.ckRecord.recordID, action: .deleteSelf)
        
        let userReference = CKReference(recordID: user.ckRecordID ?? post.ckRecord.recordID, action: .deleteSelf)
        
        let comment = Comment(post: post, text: text, user: user, postReference: postReference, userReference: userReference)
        
        ckManager.save(records: [comment.ckRecord], perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print("Error saving comment to CloudKit: \(error)")
                completion(false)
                return
            }
            
            self.postComments.append(comment)
            completion(true)
        }
        
    }
    
    func loadCommentsFor(post: Post, completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(format: "postReference == %@", post.ckRecordID ?? post.ckRecord.recordID)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        
        ckManager.fetch(type: Comment.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
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
    
    func loadUserFor(comment: Comment) -> User? {

        var fetchedUser: User?
        
        let predicate = NSPredicate(format: "recordID == %@", comment.userReference)
        
        ckManager.fetch(type: User.typeKey, predicate: predicate, sortDescriptor: nil) { (records, error) in
            if let error = error {
                print("Error fetching user for comment:\(error)")
                return
            }
            
            guard let record = records?.first else { return }
            
            fetchedUser = User(cloudKitRecord: record)

        }

        return fetchedUser

    }
    
}
