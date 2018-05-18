//
//  CKManager.swift
//  funnel
//
//  Created by Drew Carver on 5/14/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    // Access public database
    private let publicDB = CKContainer.default().publicCloudDatabase
    
    // Fetch from CloudKit
    func fetch(type: String, predicate: NSPredicate, completion: @escaping ((_ records: [CKRecord]?, _ error: Error?) -> Void)) {
        let query = CKQuery(recordType: type, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        publicDB.perform(query, inZoneWith: nil, completionHandler: completion)
    }
    
    func fetchSingleRecord(ckRecordID: CKRecordID, completion: @escaping (CKRecord?, Error?) -> Void) {
        publicDB.fetch(withRecordID: ckRecordID, completionHandler: completion)
    }
    
    // Save records to CloudKit
    func save(records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        modify(records: records, perRecordCompletion: perRecordCompletion, completion: completion)
    }
    
    // Modify CloudKit Records
    func modify(records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInitiated
        
        operation.perRecordCompletionBlock = perRecordCompletion
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            completion?(records, error)
        }
        
        publicDB.add(operation)
    }
    
    // Get user's Apple ID for object to reference
    func getUserRecordID(completion: @escaping (CKRecordID?, Error?) -> Void) {
        CKContainer.default().fetchUserRecordID(completionHandler: completion)
    }

}
