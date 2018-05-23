//
//  RevisedPost.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

//class RevisedPost {
//    static let typeKey = "RevisedPost"
//    private static let userKey = "user"
//    private static let category1RefKey = "category1Ref"
//    private static let category2RefKey = "category2Ref"
//    private static let category3RefKey = "category3Ref"
//
//
//    let description: String
//
//    var category1Ref: CKReference?
//    var category2Ref: CKReference?
//    var category3Ref: CKReference?
//
//    var followersRefs: [CKReference]
//
//    var ckRecordID: CKRecordID?
//
//    var ckRecord: CKRecord {
//        let record: CKRecord
//        if let ckRecordID = ckRecordID {
//            record = CKRecord(recordType: RevisedPost.typeKey, recordID: ckRecordID)
//        } else {
//            record = CKRecord(recordType: RevisedPost.typeKey)
//            self.ckRecordID = record.recordID
//        }
//
//        if let category1Ref = category1Ref {
//            record.setValue(category1Ref, forKey: RevisedPost.category1RefKey)
//        }
//
//        if let category2Ref = category2Ref {
//            record.setValue(category2Ref, forKey: RevisedPost.category2RefKey)
//        }
//
//        if let category3Ref = category3Ref {
//            record.setValue(category3Ref, forKey: RevisedPost.category3RefKey)
//        }
//
//        return record
//    }
//
//    init(description: String, category1: Category1, category2: Category2, category3: Category3) {
//        self.description = description
//    }
//
//}
