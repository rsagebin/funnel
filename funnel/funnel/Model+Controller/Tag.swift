//
//  Tag.swift
//  funnel
//
//  Created by Drew Carver on 5/17/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class Tag {
    static let typeKey = "Tag"
    private static let textKey = "text"
    private static let postReferenceKey = "postReference"
    
    let text: String
    var postReference: CKReference
    var ckRecordID: CKRecordID?
    var ckRecord: CKRecord {
        let record: CKRecord
        if let ckRecordID = ckRecordID {
            record = CKRecord(recordType: Tag.typeKey, recordID: ckRecordID)
        } else {
            record = CKRecord(recordType: Tag.typeKey)
        }
        
        record.setValue(text, forKey: Tag.textKey)
        record.setValue(postReference, forKey: Tag.postReferenceKey)
        
        return record
    }
    
    
    init(text: String, postReference: CKReference) {
        self.text = text
        self.postReference = postReference
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let text = cloudKitRecord[Tag.typeKey] as? String,
            let postReference = cloudKitRecord[Tag.postReferenceKey] as? CKReference else { return nil }
        
        self.text = text
        self.postReference = postReference
        
        self.ckRecordID = cloudKitRecord.recordID
    }
    
}
