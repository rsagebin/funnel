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
    private static let nameKey = "name"
    private static let postsKey = "posts"
    private static let followingKey = "following"
    private static let isBannedKey = "isBanned"
    private static let blockedUsersKey = "blockedUsers"
    private static let userRefKey = "userRef"
    private static let ckRecordIDKey = "ckRecordID"
    
    let username: String
    let name: String
    let posts: [Post]
    var following: [Post]
    var comments: [Comment]
    var isBanned: Bool
    var blockedUsers: [User]
    var ckRecordID: CKRecordID?
    var userRef: CKReference?
    var ckRecord: CKRecord {
        let record: CKRecord
        if let ckRecordID = ckRecordID {
            record = CKRecord(recordType: User.typeKey, recordID: ckRecordID)
        } else {
            record = CKRecord(recordType: User.typeKey)
        }
        
        record.setValue(username, forKey: User.usernameKey)
        record.setValue(name, forKey: User.nameKey)
        record.setValue(posts, forKey: User.postsKey)
        record.setValue(following, forKey: User.followingKey)
        record.setValue(comments, forKey: User.followingKey)
        record.setValue(isBanned, forKey: User.isBannedKey)
        record.setValue(blockedUsers, forKey: User.blockedUsersKey)
        record.setValue(ckRecordID, forKey: User.ckRecordIDKey)
        record.setValue(userRef, forKey: User.userRefKey)
        
        return record
    }
    
    init(username: String, name: String, userRef: CKReference?) {
        self.username = username
        self.name = name
        
        self.posts = []
        self.following = []
        self.comments = []
        self.isBanned = false
        self.blockedUsers = []
        self.userRef = userRef
    }
    
}
