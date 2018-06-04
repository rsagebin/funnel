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
    private static let userReferenceKey = "userReference"
    
    var post: Post?
    let text: String
    var user: User?
    let postReference: CKReference
    let userReference: CKReference
    var ckRecordID: CKRecordID
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: Comment.typeKey, recordID: ckRecordID)
        
        record.setValue(text, forKey: Comment.textKey)
        record.setValue(postReference, forKey: Comment.postReferenceKey)
        record.setValue(userReference, forKey: Comment.userReferenceKey)
        
        return record
    }
    

    init?(cloudKitRecord: CKRecord) {
        guard let postReference = cloudKitRecord[Comment.postReferenceKey] as? CKReference,
            let userReference = cloudKitRecord[Comment.userReferenceKey] as? CKReference,
            let text = cloudKitRecord[Comment.textKey] as? String else { return nil }
        
        self.postReference = postReference
        self.userReference = userReference
        self.text = text
        
        self.ckRecordID = cloudKitRecord.recordID
        
    }
    
    init(post: Post, text: String, user: User, postReference: CKReference, userReference: CKReference) {
        self.post = post
        self.text = text
        self.user = user
        self.postReference = postReference
        self.userReference = userReference
        
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
        
    }
}
