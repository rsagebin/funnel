//
//  Comment.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class Comment {
    static let typeKey = "Comment"
    private static let postKey = "post"
    private static let textKey = "text"
    private static let userKey = "user"
    private static let postReferenceKey = "postReference"
    private static let ckRecordIDKey = "ckRecordID"
    
    let post: Post
    let text: String
    let user: User
    let postReference: CKReference
    var ckRecordID: CKRecordID?
    var ckRecord: CKRecord {
        let record: CKRecord
        if let ckRecordID = ckRecordID {
            record = CKRecord(recordType: Comment.typeKey, recordID: ckRecordID)
        } else {
            record = CKRecord(recordType: Comment.typeKey)
        }
        
        record.setValue(post, forKey: Comment.postKey)
        record.setValue(text, forKey: Comment.textKey)
        record.setValue(user, forKey: Comment.userKey)
        record.setValue(postReference, forKey: Comment.postReferenceKey)
        record.setValue(ckRecordID, forKey: Comment.ckRecordIDKey)
        
        return record
    }
    
    
    init(post: Post, text: String, user: User) {
        self.post = post
        self.text = text
        self.user = user
        
        self.postReference = CKReference(record: post.ckRecord, action: .deleteSelf)
    }
}
