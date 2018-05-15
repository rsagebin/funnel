//
//  Post.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class Post {
    
    static let typeKey = "Post"
    private static let userKey = "user"
    private static let descriptionKey = "description"
    private static let imageURLKey = "imageURL"
    private static let categoryKey = "category"
    private static let tagsKey = "tags"
    private static let commentsKey = "comments"
    private static let numberOfFlagsKey = "numberOfFlags"
    private static let isBannedKey = "isBanned"
    
    let user: User
    let description: String
    let imageURL: URL
    var category: String
    var tags: [String]
    var comments: [Comment]
    var numberOfFlags: Int
    var isBanned: Bool
    
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: Post.typeKey)
        
        record.setValue(user, forKey: Post.userKey)
        record.setValue(description, forKey: Post.descriptionKey)
        record.setValue(imageURL, forKey: Post.imageURLKey)
        record.setValue(category, forKey: Post.categoryKey)
        record.setValue(tags, forKey: Post.tagsKey)
        record.setValue(comments, forKey: Post.commentsKey)
        record.setValue(numberOfFlags, forKey: Post.numberOfFlagsKey)
        record.setValue(isBanned, forKey: Post.isBannedKey)
        
        return record
    }
    
    func createCategory() -> String {
        return ""
    }
    
    init(user: User, description: String, imageURL: URL) {
        self.user = user
        self.description = description
        self.imageURL = imageURL
        self.category = ""
        
        self.comments = []
        self.tags = []
        self.numberOfFlags = 0
        self.isBanned = false
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let user = cloudKitRecord[Post.userKey] as? User,
            let description = cloudKitRecord[Post.descriptionKey] as? String,
            let imageURL = cloudKitRecord[Post.imageURLKey] as? URL,
            let category = cloudKitRecord[Post.categoryKey] as? String,
            let tags = cloudKitRecord[Post.tagsKey] as? [String],
            let comments = cloudKitRecord[Post.commentsKey] as? [Comment],
            let numberOfFlags = cloudKitRecord[Post.numberOfFlagsKey] as? Int,
            let isBanned = cloudKitRecord[Post.isBannedKey] as? Bool else { return nil }
        
        self.user = user
        self.description = description
        self.imageURL = imageURL
        self.category = category
        self.tags = tags
        self.comments = comments
        self.numberOfFlags = numberOfFlags
        self.isBanned = isBanned
        
    }
    
}
