//
//  midgetPornVolume3.swift
//  funnel
//
//  Created by Rodrigo Sagebin on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import UIKit

// MARK: - HASHTAG TEMPLATE

struct Funnel {
    let image: UIImage
    let post: String
    let hashComments: [HashComment]
    
    var hashtags: [String] {
        get {
            var tags: [String] = []
            
            for hashComment in hashComments {
                let separatedComment = hashComment.comment.components(separatedBy: " ")
                let foundTags = separatedComment.filter( { (word) -> Bool in
                    return word.hasPrefix("#")
                })
                
                tags += foundTags
            }
            return tags
        }
    }
}

struct HashComment {
    let post: String
    let comment: String
}

// Example
let firstComment = [HashComment(post: "BulletToothTony", comment: "this is a Volkswagen SP2 #vintage #VW"), HashComment(post: "GorgeousGeorge", comment: "Agreed with BulletToothTony #epic")]

let secondComment = [HashComment(post: "Turkish", comment: "Wow.... just wow."), HashComment(post: "Tommy", comment: "Love that car! #VW")]




// MARK: - CK Model Template:
/*
import CloudKit

private class CloudKitManager {
    
    MARK: - Properties for publicDataBase
    static var shared = CloudKitManager()
    let publicDB = CKContainer.default().publicCloudDatabase
 
 MARK: - TODO
 create CKPrivateDB
 let privteDB = CKContainer.default().privateCloudDatabase
    
    // Save modified or newly created Contact made in DetailVC
    func save(recordsToSave:[CKRecord], completion: @escaping (Error?) -> Void) {
        modifyRecords(recordsToSave: recordsToSave, recordIDsToDelete: nil, completion: completion)
    }
    
    // Remove Contact from CK from TVC
    func delete(recordIDsToDelete: [CKRecordID], completion: @escaping (Error?) -> Void) {
        modifyRecords(recordsToSave: nil, recordIDsToDelete: recordIDsToDelete, completion: completion)
    }
    
    // Make changes to Contacts
    func modifyRecords(recordsToSave: [CKRecord]?, recordIDsToDelete: [CKRecordID]?, completion: @escaping (Error?) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: recordIDsToDelete)
        
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        operation.perRecordCompletionBlock = nil
        operation.modifyRecordsCompletionBlock = { (_, _, error) in
            completion(error)
        }
        
        publicDB.add(operation)
    }
    
    // Obtain previous Contact records from CK, if already created.
    func fetchRecords(withRecordType recordType: String, predicate: NSPredicate, completion: @escaping ([CKRecord]?, Error?) -> Void) {
        
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil, completionHandler: completion)
    }
}
*/
 
// MARK: CKControllerFunnel

/*
class ContactController {
    
    // MARK: - Properties
    static var shared = ContactController()
    var users = [User]()
    
    func createNewContact(withName firstName: String, lastName: String, phoneNumber: String, email: String, note: String, completion: @escaping (Bool) -> Void) {
        
        let newContact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email, note: note)
        let contactRecord = CKRecord(contact: newContact)
        CloudKitManager.shared.save(recordsToSave: [contactRecord]) { (error) in
            if let error = error {
                print("Error making a new contact: \(error.localizedDescription)")
            }
        }
        
        self.contacts.append(newContact)
        completion(true)
    }
    
    //Update
    func update(contact: Contact, firstName: String, lastName: String, phoneNumber: String, email: String, note: String, completion: @escaping (Bool) -> Void) {
        contact.firstName = firstName
        contact.lastName = lastName
        contact.phoneNumber = phoneNumber
        contact.email = email
        contact.note = note
        
        let updatedContactRecord = CKRecord(contact: contact)
        
        CloudKitManager.shared.save(recordsToSave: [updatedContactRecord]) { (error) in
            if let error = error {
                print("Error making the update to CK: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    //Deleting Contacts from CK
    func delete(contact: Contact, completion: @escaping (Bool) -> Void) {
        guard let contactRecordID = contact.cloudKitRecordID else { completion (false) ; return }
        CloudKitManager.shared.delete(recordIDsToDelete: [contactRecordID]) { (error) in
            if let error = error {
                print("Mistake deleting in CK: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let index = self.contacts.index(of: contact) else { completion(false) ; return }
            self.contacts.remove(at: index)
            completion(true)
        }
    }
    
    //Fetching all Contacts
    func fetchAllContacts(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        
        CloudKitManager.shared.fetchRecords(withRecordType: Contact.contactTypeKey, predicate: predicate) { (contactRecords, error) in
            if let error = error {
                print("CKFetch Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            //Take given records and convert them into GUI
            guard let contactRecords = contactRecords else { completion(false) ; return }
            
            for contactRecord in contactRecords {
                guard let contact = Contact(ckRecord: contactRecord) else { continue }
                self.contacts.append(contact)
            }
            
            completion(true)
        }
    }
}
*/
