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
    
    var topCategories: [Category1] = []
    
    var category2Categories: [Category2] = []
    
    var category3Categories: [Category3] = []
    
    
    func loadTopLevelCategories(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        ckManager.fetch(type: Category1.typeKey, predicate: predicate, sortDescriptor: sortDescriptor) { (records, error) in
            if let error = error {
                print("Error fetching top level categories: \(error)")
                completion(false)
            }
        
            guard let categoriesArray = records?.compactMap({ Category1(cloudKitRecord: $0) }) else { return }
            
            self.topCategories = categoriesArray
        
            completion(true)
        }
        
        
    }
    
    // Only run this function once to put the categories into the cloud, if you change CloudKit containers
    func saveTopLevelCategories() {
        let topCategories: [Category1] = [Category1(title: "food"),
                                          Category1(title: "health"),
                                          Category1(title: "animals"),
                                          Category1(title: "education"),
                                          Category1(title: "transportation"),
                                          Category1(title: "tech"),
                                          Category1(title: "outdoors"),
                                          Category1(title: "personal"),
                                          Category1(title: "science"),
                                          Category1(title: "lifestyle"),
                                          Category1(title: "unknown")
            ]
        
        ckManager.save(records: topCategories.compactMap( { $0.ckRecord } ), perRecordCompletion: nil) { (_, error) in
            if let error = error {
                print("Error saving top level records to CloudKit: \(error)")
            }
            return
        }

        
    }
    
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
    

    func getCategory1Categories() {
        //
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
