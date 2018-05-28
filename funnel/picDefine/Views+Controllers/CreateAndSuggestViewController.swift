//
//  SubmitAndReviewViewController.swift
//  funnel
//
//  Created by Pedro Henrique Chiericatti on 5/14/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

class CreateAndSuggestViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    // MARK: - Properties
    var picker = UIImagePickerController()
    
    var post: Post?
    
    var category1 = CategoryController.shared.topCategories
    
    let category2 = CategoryController.shared.category2Categories
    
    let category3 = CategoryController.shared.category3Categories
    
    var category1Selected: Category1?
    
    var category2Selected: Category2?
    
    var category3Selected: Category3?
    

    // MARK: - Outlets
    
    @IBOutlet weak var mainCategoryLabel: UILabel!
    @IBOutlet weak var pickerOne: UIPickerView!
    @IBOutlet weak var pickerTwo: UIPickerView!
    @IBOutlet weak var pickerThree: UIPickerView!
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createOrSuggestOutlet: UIButton!
    
    @IBOutlet weak var newCategory2: UIButton!
    @IBOutlet weak var newCategory3: UIButton!
    
    // MARK: - Actions
    
    @IBAction func createOrSuggestPostButtonTapped(_ sender: Any) {
        
        guard let description = descriptionTextView.text, let image = postImageView.image else { return }

        if post != nil {
            guard let post = post else { return }
            RevisedPostController.shared.createRevisedPost(for: post, description: description, category1: category1Selected, category2: nil, category3: nil, tagsAsString: "")
        } else {
            PostController.shared.createPost(description: description, image: image, category1: category1Selected, category2: nil, category3: nil, tagString: "")
        }
        
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        descriptionTextView.delegate = self
        descriptionTextView.text = "Add Description..."
        descriptionTextView.textColor = UIColor.lightGray
        
        
        picker.delegate = self
//        newSubCategory2.isHidden = true
        
        
        if CategoryController.shared.topCategories.isEmpty {
            CategoryController.shared.loadTopLevelCategories { (success) in
                DispatchQueue.main.async {
                    self.category1 = CategoryController.shared.topCategories
                    self.pickerOne.reloadAllComponents()
                }
            }
        }
        
        createCameraButton()
        updateViews()
        setButtonTitle()
        setBorders()
        
        // Notifications to move view up or down when the keyboard it shown or hidden.
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAndSuggestViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAndSuggestViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Category
    
//    @IBAction func newCategory2ButtonTapped(_ sender: Any) {
//        newCategoryAlert()
//        newCategory3.isHidden = false
//    }
//
//    @IBAction func newSubCategory3ButtonTapped(_ sender: Any) {
//        newCategoryAlert()
//    }

//    func newCategoryAlert() {
//        let alert = UIAlertController(title: "New Category",
//                                      message: "Add a new Category",
//                                      preferredStyle: UIAlertControllerStyle.alert)
//
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                   style: UIAlertActionStyle.cancel,
//                                   handler: nil)
//
//        alert.addAction(cancelAction)
//
//        let createAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
//
//            guard let category2Name = alert.textFields?.first?.text else { return }
//            guard let category1Selected = self.category1Selected else { return }
//
//            let newCategory2 = Category2(title: category2Name, parent: category1Selected)
//
//            CategoryController.shared.category2Categories.append(newCategory2)
//            CategoryController.shared.addCategory2(to: category1Selected, categoryName: newCategory2.title)
//
//        }
//
//        alert.addAction(createAction)
//
//        alert.addTextField { (alertTextFieldOne: UITextField) -> Void in
//            alertTextFieldOne.placeholder = "name..."
//        }
//
//        self.present(alert, animated: true, completion: nil)
//    }
    
    // MARK: - Other functions
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    
        
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
        
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Add Description..."
            descriptionTextView.textColor = UIColor.lightGray
        }
        
        
    }
    
    func setBorders() {
        
        
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        
        mainCategoryLabel.layer.borderColor = UIColor.lightGray.cgColor
        mainCategoryLabel.layer.borderWidth = 1.0
        
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
        self.postImageView.image = post.image
        self.descriptionTextView.text = post.description
    }
    
    func createCameraButton() {
        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        
        button.setImage(#imageLiteral(resourceName: "screenshot-100"), for: .normal)
        button.addTarget(self, action: #selector(showCameraOrLibrary), for: .touchUpInside)
        let navButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = navButton
    }
    
    @objc func showCameraOrLibrary() {
        showActionSheet()
    }
    
    
    // Code to move the view up when the keyboard is shown
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    // Code to move the view down when the keyboard is hidden
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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
        
        var numberOfRows = category1.count
        
        if pickerView == pickerTwo {
            numberOfRows = category2.count
        }
        else if pickerView == pickerThree {
            numberOfRows = category3.count
        }
        
        return numberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var categoryName = ""
        
        if pickerView == pickerOne {
            categoryName = category1[row].title
        }

        else if pickerView == pickerTwo {
            categoryName = category2[row].title
        }

        else if pickerView == pickerThree {
            categoryName = category3[row].title
        }

        return categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerOne {
            category1Selected = category1[row]
            mainCategoryLabel.text = category1[row].title
            print("Category1:",category1[row].title)
        }

        else if pickerView == pickerTwo {
            category2Selected = category2[row]
            mainCategoryLabel.text = "\(category1Selected?.title  ?? "")/\(category2[row].title)"
        }

        else if pickerView == pickerThree {
            category3Selected = category3[row]
            mainCategoryLabel.text = "\(category1[row].title)/\(category2[row].title)/\(category3[row].title)"
        }
    }
}
