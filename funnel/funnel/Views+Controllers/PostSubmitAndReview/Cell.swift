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
    @IBOutlet weak var categoryOneTextField: UITextField!
    @IBOutlet weak var categoryTwoTextField: UITextField!
    @IBOutlet weak var categoryThreeTextField: UITextField!
    @IBOutlet weak var pickerOne: UIPickerView!
    @IBOutlet weak var pickerTwo: UIPickerView!
    @IBOutlet weak var pickerThree: UIPickerView!
    @IBOutlet weak var picture: UIImageView!
    
    
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
            self.categoryOneTextField.text = self.category[row]
            self.mainLabel.text = "\(self.categoryOneTextField.text!)"
            //            self.pickerOne.isHidden = true
        }
            
        else if pickerView == pickerTwo {
            self.categoryTwoTextField.text = self.subCategory[row]
            self.mainLabel.text = "\(self.categoryOneTextField.text!)/\(self.categoryTwoTextField.text!)"
            //            self.pickerTwo.isHidden = true
        }
            
        else if pickerView == pickerThree {
            self.categoryThreeTextField.text = self.subSubCategory[row]
            self.mainLabel.text = "\(self.categoryOneTextField.text!)/\(self.categoryTwoTextField.text!)/\(self.categoryThreeTextField.text!)"
            //            self.pickerThree.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
