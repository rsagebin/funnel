//
//  PhotoSelectorCell.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class CategoriesEditCreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var pickerOne: UIPickerView!
    @IBOutlet weak var pickerTwo: UIPickerView!
    @IBOutlet weak var pickerThree: UIPickerView!
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var textFieldThree: UITextField!
    
    
    
    var category = ["food", "health", "animals", "education", "transportation"]
    
    var subCategory = ["tech", "Master Chief","outdoors", "personal"]
    
    var subSubCategory = ["science", "lifestyle", "tacos", "burgers"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows : Int = category.count
        if pickerView == pickerTwo {
            countRows = self.subCategory.count
        }
        else if pickerView == pickerThree {
            countRows = self.subSubCategory.count
        }
        return countRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerOne {
            let labelOne = category[row]
            return labelOne
        }
            
        else if pickerView == pickerTwo {
            let labelTwo = subCategory[row]
            return labelTwo
        }
            
        else if pickerView == pickerThree {
            let labelThree = subSubCategory[row]
            return labelThree
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerOne {
            self.textFieldOne.text = self.category[row]
            self.mainLabel.text = "\(self.textFieldOne.text!)"
//                        self.pickerOne.isHidden = true
        }
            
        else if pickerView == pickerTwo {
            self.textFieldTwo.text = self.subCategory[row]
            self.mainLabel.text = "\(self.textFieldOne.text!)/\(self.textFieldTwo.text!)"
//                        self.pickerTwo.isHidden = true
        }
            
        else if pickerView == pickerThree {
            self.textFieldThree.text = self.subSubCategory[row]
            self.mainLabel.text = "\(self.textFieldTwo.text!)/\(self.textFieldTwo.text!)/\(self.textFieldThree.text!)"
//                        self.pickerThree.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func textFieldOnePressed(_ sender: Any) {
        self.pickerOne.didMoveToSuperview()
    }
    
    @IBAction func textFieldTwoPressed(_ sender: Any) {
        self.pickerTwo.isHidden = false
    }
    
    @IBAction func textFieldThreePressed(_ sender: Any) {
        self.pickerThree.isHidden = false
    }
    
    
    
}
