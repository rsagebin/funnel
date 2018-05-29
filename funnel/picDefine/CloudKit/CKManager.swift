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
    
    static let shared = CloudKitManager()
    
    // Fetch from CloudKit
    func fetch(type: String, predicate: NSPredicate, sortDescriptor: NSSortDescriptor?, completion: @escaping ((_ records: [CKRecord]?, _ error: Error?) -> Void)) {
        let query = CKQuery(recordType: type, predicate: predicate)
        if let sortDescriptor = sortDescriptor {
            query.sortDescriptors = [sortDescriptor]
        }
        
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
    
    // Delete a record
    func delete(recordID: CKRecordID, completion: @escaping (CKRecordID?, Error?) -> Void) {
        publicDB.delete(withRecordID: recordID, completionHandler: completion)
    }
    
    // Get user's Apple ID for object to reference
    func getUserRecordID(completion: @escaping (CKRecordID?, Error?) -> Void) {
        CKContainer.default().fetchUserRecordID(completionHandler: completion)
    }
    
    func subscribeTo(_ recordType: String, completion: @escaping ((CKSubscription?, Error?) -> Void)) {
        guard let user = UserController.shared.loggedInUser else {
            return }
        let predicate = NSPredicate(format: "creatorRef == %@", user.ckRecordID)
        let subscription = CKQuerySubscription(recordType: RevisedPost.typeKey, predicate: predicate, options: [.firesOnRecordCreation])
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "New Notification"
        notificationInfo.soundName = "default"
        notificationInfo.shouldBadge = true
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription, completionHandler: completion)
    }

}
