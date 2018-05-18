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
    
    let ckManager = CloudKitManager()
    
    static let shared = CommentController()
    
    func addCommentTo(post: Post, text: String) {
        guard let user = UserController.shared.loggedInUser else { return }
        
        let postReference = CKReference(recordID: post.ckRecordID ?? post.ckRecord.recordID, action: .deleteSelf)
        
        let userReference = CKReference(recordID: user.ckRecordID ?? post.ckRecord.recordID, action: .deleteSelf)
        
        let comment = Comment(post: post, text: text, user: user, postReference: postReference, userReference: userReference)
        
        ckManager.save(records: [comment.ckRecord], perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print("Error saving comment to CloudKit: \(error)")
                return
            }
        }
        
    }
    
    func loadCommentsFor(post: Post) -> [Comment]? {
        
        var comments: [Comment]?
        
        let predicate = NSPredicate(format: "postReference == %@", post.ckRecordID ?? post.ckRecord.recordID)
        
        ckManager.fetch(type: Comment.typeKey, predicate: predicate) { (records, error) in
            if let error = error {
                print("Error loading comments for post: \(error)")
                return
            }
            
            let commentsArray = records?.compactMap({Comment(cloudKitRecord: $0)})
            comments = commentsArray
        }
        
        return comments
    }
    
    
}
