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
    private static let imageAsCKAssetKey = "imageAsCKAsset"
    private static let categoryKey = "category"
    private static let tagsKey = "tags"
    private static let commentsKey = "comments"
    private static let isAnsweredKey = "isAnswered"
    private static let numberOfFlagsKey = "numberOfFlags"
    private static let isBannedKey = "isBanned"
    private static let creatorRefKey = "creatorRef"
    private static let followersRefsKey = "followersRefs"
    
    var user: User?
    let description: String
    let image: UIImage?
    let imageAsCKAsset: CKAsset
    var category: String
    var tags: [Tag]?
    var comments: [Comment]?
    var isAnswered: Bool
    var numberOfFlags: Int
    var isBanned: Bool
    var followersRefs: [CKReference]
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
        
        record.setValue(creatorRef, forKey: Post.creatorRefKey)
        record.setValue(description, forKey: Post.descriptionKey)
        record.setValue(imageAsCKAsset, forKey: Post.imageAsCKAssetKey)
        record.setValue(category, forKey: Post.categoryKey)
        record.setValue(isAnswered, forKey: Post.isAnsweredKey)
        record.setValue(numberOfFlags, forKey: Post.numberOfFlagsKey)
        record.setValue(isBanned, forKey: Post.isBannedKey)
//        record.setValue(followersRefs, forKey: Post.followersRefsKey)
        
        return record
    }
    
    func createCategory() -> String {
        return ""
    }
    
    init(user: User, description: String, imageAsCKAsset: CKAsset, category: String, creatorRef: CKReference) {
        self.user = user
        self.description = description
        self.image = UIImage(ckAsset: imageAsCKAsset)
        self.imageAsCKAsset = imageAsCKAsset
        self.category = category
        self.comments = []
        self.tags = []
        self.numberOfFlags = 0
        self.isBanned = false
        self.isAnswered = false
        self.creatorRef = creatorRef
        self.followersRefs = []
    }
    
    init?(cloudKitRecord: CKRecord) {
            guard let description = cloudKitRecord[Post.descriptionKey] as? String,
            let imageAsCKAsset = cloudKitRecord[Post.imageAsCKAssetKey] as? CKAsset,
            let category = cloudKitRecord[Post.categoryKey] as? String,
            let isAnswered = cloudKitRecord[Post.isAnsweredKey] as? Bool,
            let numberOfFlags = cloudKitRecord[Post.numberOfFlagsKey] as? Int,
            let isBanned = cloudKitRecord[Post.isBannedKey] as? Bool,
            let creatorRef = cloudKitRecord[Post.creatorRefKey] as? CKReference
                else { return nil }
    
        if let followersRefs = cloudKitRecord[Post.followersRefsKey] as? [CKReference] {
            self.followersRefs = followersRefs
        } else {
            self.followersRefs = []
        }
        
        self.description = description
        self.imageAsCKAsset = imageAsCKAsset
        self.image = UIImage(ckAsset: imageAsCKAsset)
        self.category = category
        self.isAnswered = isAnswered
        self.numberOfFlags = numberOfFlags
        self.isBanned = isBanned
        self.creatorRef = creatorRef
        
        self.ckRecordID = cloudKitRecord.recordID
        
    }
}
