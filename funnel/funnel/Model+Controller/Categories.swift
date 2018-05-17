//
//  Categories.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class Category {
    
    let ckManager = CloudKitManager()
    
    // MARK: - Placeholder code to test
    let category = ["food", "health", "animals", "education", "transportation", "tech", "outdoors", "personal", "science", "lifestyle"]
    
    // MARK: - Begin
    static let typeKey = "Category"
    private static let categoryOne = "topCategory"
    private static let categoryTwo = "midCategory"
    private static let categoryThree = "bottomCategory"
    private static let categoryRefKey = "categoryRef"
    private static let ckRecordIDKey = "ckRecordID"
    
    let categoryOne: [String]
    let categoryTwo: [String]?
    let categoryThree: [String]?
    var ckRecordID: CKRecordID?
    var categoryRef: CKReference?
    var ckRecord: CKRecord {
        let record: CKRecord
        if let ckRecordID = ckRecordID {
            record = CKRecord(recordType: Category.typeKey, recordID: ckRecordID)
        } else {
            record = CKRecord(recordType: Category.typeKey)
        }
        
        record.setValue(categoryOne, forKey: Category.categoryOne)
        record.setValue(categoryTwo, forKey: Category.categoryTwo)
        record.setValue(categoryThree, forKey: Category.categoryThree)
        record.setValue(ckRecordID, forKey: Category.ckRecordIDKey)
        record.setValue(categoryRef, forKey: Category.categoryRefKey)
        
        return record
    }
    
    init(categoryOne: String, categoryTwo: String?, categoryThree: String?, categoryRef: CKReference?) {
        self.categoryOne = []
        self.categoryTwo = []
        self.categoryThree = []
        self.categoryRef = categoryRef
    }
}
