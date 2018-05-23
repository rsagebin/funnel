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
    @IBOutlet weak var categoryOneAddLabel: UILabel!
    @IBOutlet weak var categoryTwoAddLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let category = CategoryController.shared.topCategories
    
    let subCategory = CategoryController.shared.category2Categories
    
    let subSubCategory = CategoryController.shared.category3Categories
//    var subCategory = ["tech", "Master Chief","outdoors", "personal"]
    
//    var subSubCategory = ["science", "lifestyle", "tacos", "burgers"]
    
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
            let labelOne = "\(category[row].title)"
            return labelOne
        }
            
        else if pickerView == pickerTwo {
            let labelTwo = subCategory[row].title
            return labelTwo
        }
            
        else if pickerView == pickerThree {
            let labelThree = subSubCategory[row].title
            return labelThree
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerOne {
            self.textFieldOne.text = "\(self.category[row].title)"
            self.mainLabel.text = "\(self.textFieldOne.text ?? " ")"
//                        self.pickerOne.isHidden = true
        }
            
        else if pickerView == pickerTwo {
            self.textFieldTwo.text = self.subCategory[row].title
            self.mainLabel.text = "\(self.textFieldOne.text ?? " ")/\(self.textFieldTwo.text ?? " ")"
//                        self.pickerTwo.isHidden = true
        }
            
        else if pickerView == pickerThree {
            self.textFieldThree.text = self.subSubCategory[row].title
            self.mainLabel.text = "\(self.textFieldOne.text ?? " ")/\(self.textFieldTwo.text ?? " ")/\(self.textFieldThree.text ?? " ")"
//                        self.pickerThree.isHidden = true
        }
    }
    
    
    @IBAction func textFieldOnePressed(_ sender: Any) {
        self.pickerOne.didMoveToSuperview()
    }
    
    func newCategoryAlert() {
        let alert = UIAlertController(title: "New Category",
                                      message: "Add a new Category",
                                      preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "Cancel",
                                   style: UIAlertActionStyle.cancel,
                                   handler: nil)
        
        alert.addAction(cancel)
        
        let OK = UIAlertAction(title: "OK",
                               style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
                                print("OK")
                                let categoryTextField = alert.textFields?[0]
                                let textField2 = alert.textFields?[1]
                                self.categoryOneAddLabel.text = categoryTextField?.text!
                                self.categoryTwoAddLabel.text = textField2?.text!
//                                categoryTextField?.text = self.mainLabel.text
                                
                                self.mainLabel.text = "\(self.textFieldOne.text ?? "ROOT")/\(self.categoryOneAddLabel.text ?? " ")/\(self.categoryTwoAddLabel.text ?? " ")"
                                
                                CategoryController.shared.addCategory2(to: self.category.first!, categoryName: categoryTextField!.text!)
        }
        
        alert.addAction(OK)
        
        alert.addTextField { (alertTextFieldOne: UITextField) -> Void in
            alertTextFieldOne.placeholder = "Category One"
        }
        
        alert.addTextField { (alertTextFieldTwo: UITextField) -> Void in
            alertTextFieldTwo.placeholder = "Category Two"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
   
    
    @IBAction func addCategoryButtonTapped(_ sender: Any) {
        print("Button is responding")
        newCategoryAlert()
    }
    
    @IBAction func textFieldTwoPressed(_ sender: Any) {
    }
    
    @IBAction func textFieldThreePressed(_ sender: Any) {
        self.pickerThree.isHidden = false
    }
}
