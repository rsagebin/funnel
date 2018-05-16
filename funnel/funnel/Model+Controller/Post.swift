//
//  Post.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

class Post {
    
    static let typeKey = "Post"
    private static let userKey = "user"
    private static let descriptionKey = "description"
    private static let imageKey = "image"
    private static let categoryKey = "category"
    private static let tagsKey = "tags"
    private static let commentsKey = "comments"
    private static let numberOfFlagsKey = "numberOfFlags"
    private static let isBannedKey = "isBanned"
    private static let creatorRefKey = "creatorRef"
    
    let user: User
    let description: String
    let image: UIImage
    var category: String
    var tags: [String]
    var comments: [Comment]
    var numberOfFlags: Int
    var isBanned: Bool
    let creatorRef: CKReference
    var ckRecordID: CKRecordID?
    
    var ckRecord: CKRecord {
        let record: CKRecord
        if let ckRecordID = ckRecordID {
            record = CKRecord(recordType: Post.typeKey, recordID: ckRecordID)
        } else {
            record = CKRecord(recordType: Post.typeKey)
            self.ckRecordID = record.recordID
        }
        
        record.setValue(user, forKey: Post.userKey)
        record.setValue(description, forKey: Post.descriptionKey)
        record.setValue(image, forKey: Post.imageKey)
        record.setValue(category, forKey: Post.categoryKey)
        record.setValue(tags, forKey: Post.tagsKey)
        record.setValue(comments, forKey: Post.commentsKey)
        record.setValue(numberOfFlags, forKey: Post.numberOfFlagsKey)
        record.setValue(isBanned, forKey: Post.isBannedKey)
        
        return record
    }
    
    func createCategory() -> String {
        return ""
    }
    
    init(user: User, description: String, image: UIImage, category: String, creatorRef: CKReference) {
        self.user = user
        self.description = description
        self.image = image
        self.category = category
        self.comments = []
        self.tags = []
        self.numberOfFlags = 0
        self.isBanned = false
        self.creatorRef = creatorRef
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let user = cloudKitRecord[Post.userKey] as? User,
            let description = cloudKitRecord[Post.descriptionKey] as? String,
            let image = cloudKitRecord[Post.imageKey] as? UIImage,
            let category = cloudKitRecord[Post.categoryKey] as? String,
            let tags = cloudKitRecord[Post.tagsKey] as? [String],
            let comments = cloudKitRecord[Post.commentsKey] as? [Comment],
            let numberOfFlags = cloudKitRecord[Post.numberOfFlagsKey] as? Int,
            let isBanned = cloudKitRecord[Post.isBannedKey] as? Bool,
            let creatorRef = cloudKitRecord[Post.creatorRefKey] as? CKReference else { return nil }
        
        self.user = user
        self.description = description
        self.image = image
        self.category = category
        self.tags = tags
        self.comments = comments
        self.numberOfFlags = numberOfFlags
        self.isBanned = isBanned
        self.creatorRef = creatorRef
        
        self.ckRecordID = cloudKitRecord.recordID
        
    }
    
}
