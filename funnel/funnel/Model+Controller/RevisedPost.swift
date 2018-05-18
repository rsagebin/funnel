//
//  RevisedPost.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation

class RevisedPost {
    let description: String
    let category1: Category1
    let category2: Category2
    let category3: Category3
    
    init(description: String, category1: Category1, category2: Category2, category3: Category3) {
        self.description = description
        self.category1 = category1
        self.category2 = category2
        self.category3 = category3
    }
    
}
