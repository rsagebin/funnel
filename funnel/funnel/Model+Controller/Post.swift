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
    private static let numberOfFlagsKey = "numberOfFlags"
    private static let isBannedKey = "isBanned"
    private static let creatorRefKey = "creatorRef"
    private static let followersRefsKey = "followersRefs"
    
    let user: User
    let description: String
    let image: UIImage?
    let imageAsCKAsset: CKAsset
    var category: String
    var tags: [String]
    var comments: [Comment]
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
        record.setValue(tags, forKey: Post.tagsKey)
        record.setValue(comments, forKey: Post.commentsKey)
        record.setValue(numberOfFlags, forKey: Post.numberOfFlagsKey)
        record.setValue(isBanned, forKey: Post.isBannedKey)
        record.setValue(followersRefs, forKey: Post.followersRefsKey)
        
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
        self.creatorRef = creatorRef
        self.followersRefs = []
    }
    
    init?(cloudKitRecord: CKRecord) {
            guard let description = cloudKitRecord[Post.descriptionKey] as? String,
            let imageAsCKAsset = cloudKitRecord[Post.imageAsCKAssetKey] as? CKAsset,
            let category = cloudKitRecord[Post.categoryKey] as? String,
            let tags = cloudKitRecord[Post.tagsKey] as? [String],
            let comments = cloudKitRecord[Post.commentsKey] as? [Comment],
            let numberOfFlags = cloudKitRecord[Post.numberOfFlagsKey] as? Int,
            let isBanned = cloudKitRecord[Post.isBannedKey] as? Bool,
            let creatorRef = cloudKitRecord[Post.creatorRefKey] as? CKReference,
            let followersRefs = cloudKitRecord[Post.followersRefsKey] as? [CKReference] else { return nil }
        
        guard let user = UserController.shared.fetchUser(ckRecordID: creatorRef.recordID) else {
            print("Error fetching post user when initializing post from CloudKit")
            return nil
        }
        
        self.user = user
        self.description = description
        self.imageAsCKAsset = imageAsCKAsset
        self.image = UIImage(ckAsset: imageAsCKAsset)
        self.category = category
        self.tags = tags
        self.comments = comments
        self.numberOfFlags = numberOfFlags
        self.isBanned = isBanned
        self.creatorRef = creatorRef
        self.followersRefs = followersRefs
        
        self.ckRecordID = cloudKitRecord.recordID
        
    }
}
