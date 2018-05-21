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
    
    let topCategories: [Category1] = [Category1(title: "food"),
                                      Category1(title: "health"),
                                      Category1(title: "animals"),
                                      Category1(title: "education"),
                                      Category1(title: "transportation"),
                                      Category1(title: "tech"),
                                      Category1(title: "outdoors"),
                                      Category1(title: "personal"),
                                      Category1(title: "science"),
                                      Category1(title: "lifestyle")
    ]
    
    var category2Categories: [Category2] = []
    
    var category3Categories: [Category3] = []
    
    
    func addCategory2(to category1: Category1, categoryName: String) {
        let category = Category2(title: categoryName, parent: category1)
        let parentRef = CKReference(recordID: category1.ckRecordID ?? category1.ckRecord.recordID, action: .deleteSelf)
        category.parentRef = parentRef
        ckManager.save(records: [category.ckRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving new category 2 to CloudKit: \(error)")
                return
            }
        }
    }
    
    func addCategory3(to category2: Category2, categoryName: String) {
        let category = Category3(title: categoryName, parent: category2)
        let parentRef = CKReference(recordID: category2.ckRecordID ?? category2.ckRecord.recordID, action: .deleteSelf)
        category.parentRef = parentRef
        ckManager.save(records: [category.ckRecord], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error saving new category 3 to CloudKit: \(error)")
                return
            }
        }
    }
    
    func loadCategories() {
        
        let predicate = NSPredicate(value: true)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        ckManager.fetch(type: Category3.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching level 3 categories: \(error)")
                return
            }
            
            let records = records?.compactMap({ Category3(cloudKitRecord: $0) }) ?? []
            
            self.category3Categories = records
            
        }
        
        ckManager.fetch(type: Category2.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching level 2 categories: \(error)")
                return
            }
            
            let records = records?.compactMap({ Category2(cloudKitRecord: $0) }) ?? []
            
            self.category2Categories = records
            
        }
        
    }
    
    func getCategory2Categories(category1: Category1) -> [Category2] {
        
        var category2array: [Category2] = []
        
        for category in self.category2Categories {
            if category.parentRef == category1.ckRecordID ?? category1.ckRecord.recordID {
                category2array.append(category)
            }
        }
        
        return category2array
    }
    
    func getCategory3Categories(category2: Category2) -> [Category3] {
        
        var category3array: [Category3] = []
        
        for category in self.category3Categories {
            if category.parentRef == category2.ckRecordID ?? category2.ckRecord.recordID {
                category3array.append(category)
            }
        }
        
        return category3array
    }
    
    
    
    func updateCategory(category: Category, name: String, completion: @escaping (Bool) -> Void) {
    
    }
    
    // delete capability in the future
    
    func fetchAllCategories(completion: @escaping (Bool) -> Void) {
        //get predicate set up
    }
}
