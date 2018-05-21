//
//  Categories.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit


let topCategories: [Category1] = [Category1(title: "food"),
                                  Category1(title: "health"),
                                  Category1(title: "animals"),
                                  Category1(title: "education"),
                                  Category1(title: "transportation"),
                                  Category1(title: "tech"),
                                  Category1(title: "outdoors"),
                                  Category1(title: "personal"),
                                  Category1(title: "science"),
                                  Category1(title: "lifestyle")
                                ]

class Category1 {
    static let typeKey = "Category1"
    private static let titleKey = "title"

    let title: String
    var children: [Category2]
    
    var ckRecordID: CKRecordID?
    var ckRecord: CKRecord {
        let record: CKRecord
        if let ckRecordID = ckRecordID {
            record = CKRecord(recordType: Category1.typeKey, recordID: ckRecordID)
        } else {
            record = CKRecord(recordType: Category1.typeKey)
            self.ckRecordID = record.recordID
        }
        
        record.setValue(title, forKey: Category1.titleKey)
        
        return record
    }
    
    init(title: String) {
        self.title = title
        self.children = []
    }
}


class Category2 {
    static let typeKey = "Category2"
    private static let titleKey = "title"
    private static let parentRefKey = "parentRef"
    
    let title: String
    let parent: Category1
    var children: [Category3]
    
    let parentRef: CKReference
    var ckRecordID: CKRecordID?
    var ckRecord: CKRecord {
        let record: CKRecord
        if let ckRecordID = ckRecordID {
            record = CKRecord(recordType: Category2.typeKey, recordID: ckRecordID)
        } else {
            record = CKRecord(recordType: Category2.typeKey)
            self.ckRecordID = record.recordID
        }
        
        record.setValue(title, forKey: Category2.titleKey)
        record.setValue(parentRef, forKey: Category2.parentRefKey)
        
        return record
    }
    
    init(title: String, parent: Category1) {
        self.title = title
        self.parent = parent
        
        let reference = CKReference(recordID: parent.ckRecordID ?? parent.ckRecord.recordID, action: .deleteSelf)
        self.parentRef = reference
        self.children = []
    }
}


class Category3 {
    static let typeKey = "Category3"
    private static let titleKey = "title"
    private static let parentRefKey = "parentRef"
    
    let title: String
    let parent: Category2
    var children: [String]
    
    let parentRef: CKReference
    var ckRecordID: CKRecordID?
    var ckRecord: CKRecord {
        let record: CKRecord
        if let ckRecordID = ckRecordID {
            record = CKRecord(recordType: Category3.typeKey, recordID: ckRecordID)
        } else {
            record = CKRecord(recordType: Category3.typeKey)
            self.ckRecordID = record.recordID
        }
        
        record.setValue(title, forKey: Category3.titleKey)
        record.setValue(parentRef, forKey: Category3.parentRefKey)
        
        return record
    }
    
    init(title: String, parent: Category2) {
        self.title = title
        self.parent = parent
        
        let reference = CKReference(recordID: parent.ckRecordID ?? parent.ckRecord.recordID, action: .deleteSelf)
        self.parentRef = reference
        self.children = []
    }
}
