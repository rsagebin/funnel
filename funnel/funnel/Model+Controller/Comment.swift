//
//  Comment.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class Comment {
    let post: Post
    let text: String
    let user: User
    
    let postReference: CKReference
    
    init(post: Post, text: String, user: User) {
        self.post = post
        self.text = text
        self.user = user
        
        self.postReference = CKReference(record: post.ckRecord, action: .deleteSelf)
    }
}
