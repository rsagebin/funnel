//
//  User.swift
//  funnel
//
//  Created by Drew Carver on 5/14/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class User {
    static let typeKey = "User"
    private static let usernameKey = "username"
    private static let emailKey = "email"
    private static let nameKey = "name"
    private static let postsKey = "posts"
    private static let followingKey = "following"
    private static let commentsKey = "comments"
    private static let commentRefsKey = "commentRefs"
    private static let isBannedKey = "isBanned"
    private static let blockedUsersKey = "blockedUsers"
    private static let appleUserRefKey = "appleUserRef"
    private static let ckRecordIDKey = "ckRecordID"
    
    let username: String
    let name: String
    var email: String
    var posts: [Post]?
    var following: [Post]?
    var comments: [Comment]?
    var commentRefs: [CKReference]
    var isBanned: Bool
    var blockedUsers: [CKReference]
    var ckRecordID: CKRecordID
    var appleUserRef: CKReference?
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: User.typeKey, recordID: self.ckRecordID)
        
        record.setValue(username, forKey: User.usernameKey)
        record.setValue(name, forKey: User.nameKey)
        record.setValue(email, forKey: User.emailKey)
        record.setValue(commentRefs, forKey: User.commentRefsKey)
        record.setValue(isBanned, forKey: User.isBannedKey)
        record.setValue(blockedUsers, forKey: User.blockedUsersKey)
        record.setValue(appleUserRef, forKey: User.appleUserRefKey)
        
        return record
    }
    
    init(username: String, name: String, email: String, appleUserRef: CKReference?) {
        self.username = username
        self.name = name
        self.email = email
        
        self.posts = []
        self.following = []
        self.comments = []
        self.commentRefs = []
        self.isBanned = false
        self.blockedUsers = []
        self.appleUserRef = appleUserRef
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let username = cloudKitRecord[User.usernameKey] as? String,
            let name = cloudKitRecord[User.nameKey] as? String,
            let email = cloudKitRecord[User.emailKey] as? String,
            let isBanned = cloudKitRecord[User.isBannedKey] as? Bool,
            let appleUserRef = cloudKitRecord[User.appleUserRefKey] as? CKReference else { return nil }

        if let commentRefs = cloudKitRecord[User.commentRefsKey] as? [CKReference] {
            self.commentRefs = commentRefs
        } else {
            self.commentRefs = []
        }
        
        if let blockedUsers = cloudKitRecord[User.blockedUsersKey] as? [CKReference] {
            self.blockedUsers = blockedUsers
        } else {
            self.blockedUsers = []
        }
        
        self.username = username
        self.name = name
        self.email = email
        self.isBanned = isBanned
        self.appleUserRef = appleUserRef
        
        self.ckRecordID = cloudKitRecord.recordID
        
    }
    
}
