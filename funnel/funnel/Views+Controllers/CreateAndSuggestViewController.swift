//
//  SubmitAndReviewViewController.swift
//  funnel
//
//  Created by Pedro Henrique Chiericatti on 5/14/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

class CreateAndSuggestViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    var picker = UIImagePickerController()
    
    var post: Post?
    
    var category = CategoryController.shared.topCategories
    
    let subCategory = CategoryController.shared.category2Categories
    
    let subSubCategory = CategoryController.shared.category3Categories

    // MARK: - Outlets
    
    @IBOutlet weak var mainCategoryLabel: UILabel!
    @IBOutlet weak var pickerOne: UIPickerView!
    @IBOutlet weak var pickerTwo: UIPickerView!
    @IBOutlet weak var pickerThree: UIPickerView!
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var tagsTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createOrSuggestOutlet: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func createOrSuggestPostButtonTapped(_ sender: Any) {
        
        guard let image = postImageView.image, let description = descriptionTextView.text, let categoryAsString = mainCategoryLabel.text, let tags = tagsTextView.text else { return }

        PostController.shared.createPost(description: description, image: image, category1: nil, category2: nil, category3: nil, tagString: tags)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        createCameraButton()
        updateViews()
        setButtonTitle()
        setBorders()
    }
    
    // MARK: - Category
    
    @IBAction func newCategoryButtonTapped(_ sender: Any) {
        newCategoryAlert()
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
//                                self.categoryOneAddLabel.text = categoryTextField?.text!
//                                self.categoryTwoAddLabel.text = textField2?.text!
                                //                                categoryTextField?.text = self.mainLabel.text
                                
                                self.mainCategoryLabel.text = "\(alert.textFields?[0].text ?? " ")/\(alert.textFields?[1].text ?? " ")"
                                
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
    
    // MARK: - Other functions
    
    func setBorders() {
        
        tagsTextView.layer.borderColor = UIColor.lightGray.cgColor
        tagsTextView.layer.borderWidth = 1.0

        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1.0
    }
    
    func setButtonTitle() {
        
        if post != nil {
            self.createOrSuggestOutlet.setTitle("Suggest change", for: .normal)
        } else {
            self.createOrSuggestOutlet.setTitle("Create new post", for: .normal)
        }
    }
    
    func updateViews() {
        guard let post = post else { return }
//        self.category = post.category
        
        TagController.shared.fetchTagsFor(post: post) { (tags) in
            DispatchQueue.main.async {
                 self.tagsTextView.text = tags
            }
        }
      
        self.postImageView.image = post.image
        self.descriptionTextView.text = post.description
    }
    
    func createCameraButton() {
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        
        button.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        button.addTarget(self, action: #selector(showCameraOrLibrary), for: .touchUpInside)
        let navButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = navButton
    }
    
    @objc func showCameraOrLibrary() {
        showActionSheet()
    }
    
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            // show camera
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
               
                self.picker.allowsEditing = true
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
                
            } else {
                // no comera
                
                let alertVC = UIAlertController(
                    title: "No Camera",
                    message: "Sorry, this device has no camera",
                    preferredStyle: .alert)
                let okAction = UIAlertAction(
                    title: "OK",
                    style:.default,
                    handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        
        let goToLibrary = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            // take to library

            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(takePhoto)
        actionSheet.addAction(goToLibrary)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerDelegate functions
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {

        guard let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        postImageView.contentMode = .scaleAspectFit
        postImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: - Categories Picker Methods

extension CreateAndSuggestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
            self.mainCategoryLabel.text = "\(self.category[row].title)"
//            self.mainLabel.text = "\(self.textFieldOne.text ?? " ")"
            //                        self.pickerOne.isHidden = true
        }
            
        else if pickerView == pickerTwo {
//            self.textFieldTwo.text = self.subCategory[row].title
            self.mainCategoryLabel.text = "\(self.category[row].title )/\(self.subCategory[row].title)"
            //                        self.pickerTwo.isHidden = true
        }
            
        else if pickerView == pickerThree {
//            self.textFieldThree.text = self.subSubCategory[row].title
            self.mainCategoryLabel.text = "\(self.category[row].title)/\(self.subCategory[row].title)/\(self.subSubCategory[row].title)"
            //                        self.pickerThree.isHidden = true
        }
    }
}
