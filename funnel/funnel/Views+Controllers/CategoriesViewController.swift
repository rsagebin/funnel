//
//  CategoriesViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var categoryOneTextField: UITextField!
    @IBOutlet weak var categoryTwoTextField: UITextField!
    @IBOutlet weak var categoryThreeTextField: UITextField!
    
    //    let category1 = CategoriesViewController.
    
    let categoryOne = ["food", "health", "animals", "education", "transportation", "tech", "outdoors", "personal", "science", "lifestyle"]
    
    let categoryTwo = ["food", "health", "animals", "education", "transportation", "tech", "outdoors", "personal", "science", "lifestyle"]
    
    let categoryThree = ["food", "health", "animals", "education", "transportation", "tech", "outdoors", "personal", "science", "lifestyle"]
    
    var selectedCategoryOne: String?
    var selectedCategoryTwo: String?
    var selectedCategoryThree: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.loadGif(name: "raining1")
        createCategoryPickerOne()
        createCategoryPickerTwo()
        createCategoryPickerThree()
    }
    
    func createCategoryPickerOne() {
        let categoryPickerOne = UIPickerView()
        categoryPickerOne.delegate = self
        categoryOneTextField.inputView = categoryPickerOne
    }
    
    func createCategoryPickerTwo() {
        let categoryPickerTwo = UIPickerView()
        categoryPickerTwo.delegate = self
        categoryTwoTextField.inputView = categoryPickerTwo
    }
    
    func createCategoryPickerThree() {
        let categoryPickerThree = UIPickerView()
        categoryPickerThree.delegate = self
        categoryThreeTextField.inputView = categoryPickerThree
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
        return categoryOne.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryOne[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategoryOne = categoryOne[row]
        categoryOneTextField.text = selectedCategoryOne
        pickerView .removeFromSuperview()
    }
    
    // Picker Two
    func numberOfComponentsTwo(in pickerViewTwo: UIPickerView) -> Int {
        return 1
    }
    
    func pickerViewTwo(_ pickerViewTwo: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryTwo.count
    }
    
    func pickerViewTwo(_ pickerViewTwo: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryTwo[row]
    }
    
    func pickerViewTwo(_ pickerViewTwo: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategoryTwo = categoryTwo[row]
        categoryTwoTextField.text = selectedCategoryTwo
        pickerViewTwo .removeFromSuperview()
    }
}
