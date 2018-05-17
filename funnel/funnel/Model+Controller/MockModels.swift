//
//  MockModels.swift
//  funnel
//
//  Created by Drew Carver on 5/17/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class MockPost {
    let user = MockUser()
    let description: String = ""
    let image = UIImage()
    var category: String = ""
    var tags: [String] = []
    var comments: [MockComment] = []
}


class MockComment {
    let post = MockPost()
    let text: String = ""
    let user = MockUser()
}

class MockUser {
    let username: String = ""
    let name: String = ""
    var email: String = ""
    let posts: [MockPost] = []
    var following: [MockPost] = []
    var comments: [Comment] = []
    
}


