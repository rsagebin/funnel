//
//  CategoriesController.swift
//  funnel
//
//  Created by Drew Carver on 5/17/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import Foundation
import CloudKit

class CategoryController {
    let ckManager = CloudKitManager()

    static var shared = CategoryController()
   
    let categories: [String:[[String:[String]]]] = [
        "food":[
            ["mexican":
                ["tortillas","sopa"]],
            ["italian":
                ["pasta","vino"]]
        ],
        "health":[[:]],
        "animals":[[:]],
        "education":[[:]],
        "transportation":[[:]],
        "tech":[[:]],
        "outdoors":[[:]],
        "personal":[[:]],
        "science":[[:]],
        "lifestyle":[[:]]
    ]
    
    func createNewSubCategory(within: String) {
        
    }
    
    func loadTopLevelCategory() {
        
    }
    
    func loadSubCategory(categoryAbove: String) {
        
    }
    
    func loadSubSubCategory(categoryAbove: String) {
        
    }
    
    
    func updateCategory(category: Category, name: String, completion: @escaping (Bool) -> Void) {
    
    }
    
    // delete capability in the future
    
    func fetchAllCategories(completion: @escaping (Bool) -> Void) {
        //get predicate set up
    }
}
