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
//            self.mainLabel.text = "\(self.textFieldTwo.text!)/\(self.textFieldTwo.text!)/\(self.textFieldThree.text!)"
//                        self.pickerThree.isHidden = true
        }
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        createAlert(title: "Add Category", message: "Add your new category")
//    }
//
//    func createAlert (title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//
//        alert.addAction(UIAlertAction(title: "Add Category", style: UIAlertActionStyle.default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//
//        self.present(alert, animated: true, completion: nil)
//    }
    
    @IBAction func textFieldOnePressed(_ sender: Any) {
        self.pickerOne.didMoveToSuperview()
    }
    
    
    
   
    
    @IBAction func addCategoryButtonTapped(_ sender: Any) {
        print("Button is responding")
        
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
                                    var textField = alert.textFields?[1]
                                    print("Dunno")
                                    textField?.text = self.mainLabel.text
                                    self.mainLabel.text = "\(self.categoryOneAddLabel.text!)/\(self.categoryTwoAddLabel.text!)"
            }
            
            alert.addAction(OK)
            
            alert.addTextField { (textField: UITextField) -> Void in
                textField.placeholder = "UNKNOWN"
            }
            
            alert.addTextField { (textField: UITextField) -> Void in
                textField.placeholder = "UNKNOWN"
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func textFieldTwoPressed(_ sender: Any) {
//        let alert = UIAlertController(title: "New Category", message: "Add a new Category", preferredStyle: UIAlertControllerStyle.alert)
//
//        alert.addTextField { (textField) -> Void in
//        }
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//            let textf = alert.textFields![0] as UITextField
//            print(textf.text!)
//        }))
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
//            self.dismiss(animated: true, completion: nil)
//        }))
//
//        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func textFieldThreePressed(_ sender: Any) {
        self.pickerThree.isHidden = false
    }

}
