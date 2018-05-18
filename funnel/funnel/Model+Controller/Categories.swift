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
    }
}


class Category2 {
    static let typeKey = "Category2"
    private static let titleKey = "title"
    private static let parentRefKey = "parentRef"
    
    let title: String
    let parent: Category1
    
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
    }
}


class Category3 {
    static let typeKey = "Category3"
    private static let titleKey = "title"
    private static let parentRefKey = "parentRef"
    
    let title: String
    let parent: Category2
    
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
    }
}







class Category {

    let ckManager = CloudKitManager()
    
    let categoriesDict: [String:[[String:[String]]]] = [
        "food":[
            ["mexican":
                ["tortillas","sopa"]],
            ["italian":
                ["pasta","vino"]]
        ],
        "health":[[:]],
        "animals":[[:]],
        "education":[[:]],
        "transportation":[[:]],
        "tech":[[:]],
        "outdoors":[[:]],
        "personal":[[:]],
        "science":[[:]],
        "lifestyle":[[:]]
    ]

    
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
