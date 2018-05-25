//
//  Categories.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit


class Category1 {
    static let typeKey = "Category1"
    private static let titleKey = "title"

    let title: String
    var children: [Category2]?
    
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
    
    init?(cloudKitRecord: CKRecord) {
        guard let title = cloudKitRecord[Category1.titleKey] as? String
            else { return nil }
        
        self.title = title
        self.ckRecordID = cloudKitRecord.recordID
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
    var parent: Category1?
    var children: [Category3]?
    
    var parentRef: CKReference
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
    
    init?(cloudKitRecord: CKRecord) {
        guard let title = cloudKitRecord[Category2.titleKey] as? String,
            let parentRef = cloudKitRecord[Category2.parentRefKey] as? CKReference
                else { return nil }
        
        self.title = title
        self.parentRef = parentRef
        self.ckRecordID = cloudKitRecord.recordID
        
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
    var parent: Category2?
    var children: [String]?
    
    var parentRef: CKReference
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
    
    init?(cloudKitRecord: CKRecord) {
        guard let title = cloudKitRecord[Category3.titleKey] as? String,
            let parentRef = cloudKitRecord[Category3.parentRefKey] as? CKReference
            else { return nil }
        
        self.title = title
        self.parentRef = parentRef
        self.ckRecordID = cloudKitRecord.recordID
        
    }
    
    init(title: String, parent: Category2) {
        self.title = title
        self.parent = parent
        
        let reference = CKReference(recordID: parent.ckRecordID ?? parent.ckRecord.recordID, action: .deleteSelf)
        self.parentRef = reference
        self.children = []
    }
}

protocol Category {
    
}
