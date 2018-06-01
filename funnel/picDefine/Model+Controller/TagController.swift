//
//  TagController.swift
//  funnel
//
//  Created by Drew Carver on 5/17/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class TagController {
    
    static let shared = TagController()
    
    func saveTagsOnPost(post: Post, tagString: String) {
        
        let textSeparatedBySpaces = tagString.components(separatedBy: " ")
        let tagsAsStrings = textSeparatedBySpaces.filter { (word) -> Bool in
            return word.hasPrefix("#")
        }
        
        let postReference = CKReference(recordID: post.ckRecordID, action: .deleteSelf)
        
        for string in tagsAsStrings {
            let tag = Tag(text: string, postReference: postReference)
            
            CloudKitManager.shared.save(records: [tag.ckRecord], perRecordCompletion: nil) { (records, error) in
                if let error = error {
                    print("Error saving tag to CloudKit: \(error)")
                    return
                }
            }
        }
    }
    
    func saveTagsOnRevisedPost(post: RevisedPost, tagString: String) {
        
        let textSeparatedBySpaces = tagString.components(separatedBy: " ")
        let tagsAsStrings = textSeparatedBySpaces.filter { (word) -> Bool in
            return word.hasPrefix("#")
        }
        
        let postReference = CKReference(recordID: post.ckRecordID, action: .deleteSelf)
        
        for string in tagsAsStrings {
            let tag = Tag(text: string, postReference: postReference)
            
            CloudKitManager.shared.save(records: [tag.ckRecord], perRecordCompletion: nil) { (records, error) in
                if let error = error {
                    print("Error saving tag to CloudKit: \(error)")
                    return
                }
            }
        }
    }
    
    
    func fetchTagsFor(post: Post, completion: @escaping ([Tag]?) -> Void) {
        
        let predicate = NSPredicate(format: "postReference == %@", post.ckRecordID)
        
        CloudKitManager.shared.fetch(type: Tag.typeKey, predicate: predicate, sortDescriptor: nil) { (records, error) in
            if let error = error {
                print("Error loading tags for post: \(error)")
                completion(nil)
                return
            }
            
            guard let tagsArray = records?.compactMap({Tag(cloudKitRecord: $0)}) else { return }
            completion(tagsArray)
        }
        
    }
    
    func fetchTagsFor(post: Post, completion: @escaping (String?) -> Void) {
        let predicate = NSPredicate(format: "postReference == %@", post.ckRecordID)
        
        CloudKitManager.shared.fetch(type: Tag.typeKey, predicate: predicate, sortDescriptor: nil) { (records, error) in
            if let error = error {
                print("Error loading tags for post: \(error)")
                completion(nil)
                return
            }
            
            guard let tagsArray = records?.compactMap({Tag(cloudKitRecord: $0)}) else { return }
            
            let tagsAsStringArray = tagsArray.compactMap({ $0.text })
            
            let tagsAsString = tagsAsStringArray.joined(separator: " ")
            
            completion(tagsAsString)
        }
    }
}
