//
//  RevisedPost.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

class RevisedPost {
    static let typeKey = "RevisedPost"
    private static let descriptionKey = "description"
    private static let category1RefKey = "category1Ref"
    private static let category2RefKey = "category2Ref"
    private static let category3RefKey = "category3Ref"
    private static let categoryAsStringKey = "categoryAsString"
    private static let followersRefsKey = "followersRefs"
    private static let imageAsCKAssetKey = "imageAsCKAsset"
    private static let creatorRefKey = "creatorRef"
    private static let revisedPostCreatorRefKey = "revisedPostCreatorRef"
    private static let postReferenceKey = "postReference"
    

    let description: String

    var image: UIImage?
    let imageAsCKAsset: CKAsset
    
    var tags: [Tag]?
    
    var category1Ref: CKReference?
    var category2Ref: CKReference?
    var category3Ref: CKReference?
    
    var categoryAsString = ""

    let creatorRef: CKReference
    
    let revisedPostCreatorRef: CKReference
    
    let postReference: CKReference
    
    var followersRefs: [CKReference]?

    var ckRecordID: CKRecordID

    var ckRecord: CKRecord {
        let record = CKRecord(recordType: RevisedPost.typeKey, recordID: self.ckRecordID)

        if let category1Ref = category1Ref {
            record.setValue(category1Ref, forKey: RevisedPost.category1RefKey)
        }

        if let category2Ref = category2Ref {
            record.setValue(category2Ref, forKey: RevisedPost.category2RefKey)
        }

        if let category3Ref = category3Ref {
            record.setValue(category3Ref, forKey: RevisedPost.category3RefKey)
        }
        
        record.setValue(description, forKey: RevisedPost.descriptionKey)
        record.setValue(categoryAsString, forKey: RevisedPost.categoryAsStringKey)
        record.setValue(creatorRef, forKey: RevisedPost.creatorRefKey)
        record.setValue(postReference, forKey: RevisedPost.postReferenceKey)
        record.setValue(revisedPostCreatorRef, forKey: RevisedPost.revisedPostCreatorRefKey)
        record.setValue(imageAsCKAsset, forKey: RevisedPost.imageAsCKAssetKey)

        return record
    }

    init?(cloudKitRecord: CKRecord) {
        guard let description = cloudKitRecord[RevisedPost.descriptionKey] as? String,
            let creatorRef = cloudKitRecord[RevisedPost.creatorRefKey] as? CKReference,
            let revisedPostCreatorRef = cloudKitRecord[RevisedPost.revisedPostCreatorRefKey] as? CKReference,
            let categoryAsString = cloudKitRecord[RevisedPost.categoryAsStringKey] as? String,
            let imageCKAsset = cloudKitRecord[RevisedPost.imageAsCKAssetKey] as? CKAsset,
            let postReference = cloudKitRecord[RevisedPost.postReferenceKey] as? CKReference
            else { return nil }

        if let category1Ref = cloudKitRecord[RevisedPost.category1RefKey] as? CKReference {
            self.category1Ref = category1Ref
        }

        if let category2Ref = cloudKitRecord[RevisedPost.category2RefKey] as? CKReference {
            self.category2Ref = category2Ref
        }

        if let category3Ref = cloudKitRecord[RevisedPost.category3RefKey] as? CKReference {
            self.category3Ref = category3Ref
        }
        
        self.description = description
        self.creatorRef = creatorRef
        self.categoryAsString = categoryAsString
        self.postReference = postReference
        self.revisedPostCreatorRef = revisedPostCreatorRef
        self.imageAsCKAsset = imageCKAsset
        self.image = UIImage(ckAsset: imageCKAsset)
        
        self.ckRecordID = cloudKitRecord.recordID
        
    }

    init(post: Post, description: String, revisedPostCreatorRef: CKReference, category1Ref: CKReference?, category2Ref: CKReference?, category3Ref: CKReference?, imageCKAsset: CKAsset) {
        self.description = description
        self.creatorRef = post.creatorRef
        self.category1Ref = category1Ref
        self.category2Ref = category2Ref
        self.category3Ref = category3Ref
        self.imageAsCKAsset = imageCKAsset
        
        let postReference = CKReference(recordID: post.ckRecordID, action: .deleteSelf)
        self.postReference = postReference
        
        self.revisedPostCreatorRef = revisedPostCreatorRef
        
        self.ckRecordID = CKRecordID(recordName: UUID().uuidString)
        
    }

}

extension RevisedPost: Equatable {
    static func ==(lhs: RevisedPost, rhs: RevisedPost) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
