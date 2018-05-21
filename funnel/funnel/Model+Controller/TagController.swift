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
    
    let ckManager = CloudKitManager()
    
    static let shared = TagController()
    
    func createTagOn(post: Post, text: String) {
        
        let postReference = CKReference(recordID: post.ckRecordID ?? post.ckRecord.recordID, action: .deleteSelf)
        
        let tag = Tag(text: text, postReference: postReference)
        
        ckManager.save(records: [tag.ckRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving tag to CloudKit: \(error)")
                return
            }
        }
        
        func fetchTagsFor(post: Post) -> [Tag] {
            var tags: [Tag] = []
            
            let predicate = NSPredicate(format: "postReference == %@", post.ckRecordID ?? post.ckRecord.recordID)
            
            ckManager.fetch(type: Tag.typeKey, predicate: predicate) { (records, error) in
                if let error = error {
                    print("Error loading tags for post: \(error)")
                    return
                }
                
                guard let tagsArray = records?.compactMap({Tag(cloudKitRecord: $0)}) else { return }
                tags = tagsArray
            }
            
            return tags
        }
    }
    
    
}
