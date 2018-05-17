//
//  CategoriesViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    @IBOutlet weak var category1Picker: UIPickerView!
    @IBOutlet weak var category2Picker: UIPickerView!
    @IBOutlet weak var category3Picker: UIPickerView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    let category = ["food", "health", "animals", "education", "transportation", "tech", "outdoors", "personal", "science", "lifestyle"]
    
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.backgroundColor = UIColor(patternImage: )

        //backgroundGif.loadGif(asset: "inception")
    }
    
    @IBAction func categorySearchButtonTapped(_ sender: Any) {
        
        // segue to feedVC listing cells of items within the specified category(ies)
    }
    
}

extension CategoriesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = category[row]
        categoryLabel.text = selectedCategory
    }
}


