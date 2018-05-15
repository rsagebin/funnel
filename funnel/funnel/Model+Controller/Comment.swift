//
//  Comment.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation

class Comment {
    let text: String
    let user: User
    
    init(text: String, user: User) {
        self.text = text
        self.user = user
    }
}
