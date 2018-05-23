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
    private static let categoryAsStringKey = "categoryAsString"
    private static let tagsKey = "tags"
    private static let commentsKey = "comments"
    private static let isAnsweredKey = "isAnswered"
    private static let numberOfFlagsKey = "numberOfFlags"
    private static let isBannedKey = "isBanned"
    private static let creatorRefKey = "creatorRef"
    private static let followersRefsKey = "followersRefs"
    private static let category1RefKey = "category1Ref"
    private static let category2RefKey = "category2Ref"
    private static let category3RefKey = "category3Ref"
    
    var user: User?
    let description: String
    let image: UIImage?
    let imageAsCKAsset: CKAsset
    var tags: [Tag]?
    var comments: [Comment]?
    var isAnswered: Bool
    var numberOfFlags: Int
    var isBanned: Bool
    
    var category1Ref: CKReference?
    var category2Ref: CKReference?
    var category3Ref: CKReference?
    
    var categoryAsString: String = ""
    
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
        record.setValue(isAnswered, forKey: Post.isAnsweredKey)
        record.setValue(numberOfFlags, forKey: Post.numberOfFlagsKey)
        record.setValue(isBanned, forKey: Post.isBannedKey)
        record.setValue(categoryAsString, forKey: Post.categoryAsStringKey)
        
        if let category1Ref = category1Ref {
            record.setValue(category1Ref, forKey: Post.category1RefKey)
        }
        
        if let category2Ref = category2Ref {
            record.setValue(category2Ref, forKey: Post.category2RefKey)
        }
        
        if let category3Ref = category3Ref {
            record.setValue(category3Ref, forKey: Post.category3RefKey)
        }
        
        record.setValue(followersRefs, forKey: Post.followersRefsKey)
        
        return record
    }
    
    init(user: User, description: String, imageAsCKAsset: CKAsset, creatorRef: CKReference, category1Ref: CKReference?, category2Ref: CKReference?, category3Ref: CKReference?) {
        self.user = user
        self.description = description
        self.image = UIImage(ckAsset: imageAsCKAsset)
        self.imageAsCKAsset = imageAsCKAsset
        self.comments = []
        self.tags = []
        self.category1Ref = category1Ref
        self.category2Ref = category2Ref
        self.category3Ref = category3Ref
        self.numberOfFlags = 0
        self.isBanned = false
        self.isAnswered = false
        self.creatorRef = creatorRef
        self.followersRefs = []
    }
    
    init?(cloudKitRecord: CKRecord) {
            guard let description = cloudKitRecord[Post.descriptionKey] as? String,
            let imageAsCKAsset = cloudKitRecord[Post.imageAsCKAssetKey] as? CKAsset,
            let isAnswered = cloudKitRecord[Post.isAnsweredKey] as? Bool,
            let numberOfFlags = cloudKitRecord[Post.numberOfFlagsKey] as? Int,
            let isBanned = cloudKitRecord[Post.isBannedKey] as? Bool,
            let creatorRef = cloudKitRecord[Post.creatorRefKey] as? CKReference,
            let categoryAsString = cloudKitRecord[Post.categoryAsStringKey] as? String
                else { return nil }
    
        if let followersRefs = cloudKitRecord[Post.followersRefsKey] as? [CKReference] {
            self.followersRefs = followersRefs
        } else {
            self.followersRefs = []
        }

        if let category1Ref = cloudKitRecord[Post.category1RefKey] as? CKReference {
            self.category1Ref = category1Ref
        }
        
        if let category2Ref = cloudKitRecord[Post.category2RefKey] as? CKReference {
            self.category2Ref = category2Ref
        }
        
        if let category3Ref = cloudKitRecord[Post.category3RefKey] as? CKReference {
            self.category3Ref = category3Ref
        }
        
        self.description = description
        self.imageAsCKAsset = imageAsCKAsset
        self.image = UIImage(ckAsset: imageAsCKAsset)
        self.isAnswered = isAnswered
        self.numberOfFlags = numberOfFlags
        self.isBanned = isBanned
        self.creatorRef = creatorRef
        self.categoryAsString = categoryAsString
        
        self.ckRecordID = cloudKitRecord.recordID
        
    }
}
