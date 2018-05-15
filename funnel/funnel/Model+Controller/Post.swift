//
//  Post.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation

class Post {
    let description: String
    let imageURL: URL
    var category: String
    var comments: [Comment]
    var numberOfFlags: Int
    var isBanned: Bool
    
    func createCategory() -> String {
        return ""
    }
    
    init(description: String, imageURL: URL) {
        self.description = description
        self.imageURL = imageURL
        self.category = ""
        
        self.comments = []
        self.numberOfFlags = 0
        self.isBanned = false
    }
    
}
