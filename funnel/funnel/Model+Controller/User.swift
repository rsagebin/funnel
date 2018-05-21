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
    var isBanned: Bool
    var blockedUsers: [CKReference]
    var ckRecordID: CKRecordID?
    var appleUserRef: CKReference?
    var ckRecord: CKRecord {
        let record: CKRecord
        if let ckRecordID = ckRecordID {
            record = CKRecord(recordType: User.typeKey, recordID: ckRecordID)
        } else {
            record = CKRecord(recordType: User.typeKey)
            self.ckRecordID = record.recordID
        }
        
        record.setValue(username, forKey: User.usernameKey)
        record.setValue(name, forKey: User.nameKey)
        record.setValue(email, forKey: User.emailKey)
        record.setValue(isBanned, forKey: User.isBannedKey)
//        record.setValue(blockedUsers, forKey: User.blockedUsersKey)
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
        self.isBanned = false
        self.blockedUsers = []
        self.appleUserRef = appleUserRef
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let username = cloudKitRecord[User.usernameKey] as? String,
            let name = cloudKitRecord[User.nameKey] as? String,
            let email = cloudKitRecord[User.emailKey] as? String,
            let isBanned = cloudKitRecord[User.isBannedKey] as? Bool,
            let appleUserRef = cloudKitRecord[User.appleUserRefKey] as? CKReference,
            let blockedUsers = cloudKitRecord[User.blockedUsersKey] as? [CKReference] else { return nil }
        
        self.username = username
        self.name = name
        self.email = email
        self.isBanned = isBanned
        self.appleUserRef = appleUserRef
        self.blockedUsers = blockedUsers
        
        self.ckRecordID = cloudKitRecord.recordID
        
    }
    
}
