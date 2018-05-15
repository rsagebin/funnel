//
//  User.swift
//  funnel
//
//  Created by Drew Carver on 5/14/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation

class User {
    let username: String
    let name: String
    let posts: [Post]
    var comments: [Comment]
    var isBanned: Bool
    var blockedUsers: [User]
    
    init(username: String, name: String) {
        self.username = username
        self.name = name
        
        self.posts = []
        self.comments = []
        self.isBanned = false
        self.blockedUsers = []
    }
    
}
