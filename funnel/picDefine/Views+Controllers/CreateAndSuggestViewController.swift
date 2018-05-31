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
    
    lazy var picker: UIImagePickerController = {
        return UIImagePickerController()
    }()
    
    var post: Post?
    
    var revisedPost: RevisedPost?
    
    var category1 = CategoryController.shared.topCategories
    
    var category1Selected: Category1?
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainCategoryLabel: UITextField!
    
    @IBOutlet weak var pickerOne: UIPickerView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createOrSuggestOutlet: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCategoryLabel.inputView = pickerOne

        postImageView.layer.borderColor = UIColor.lightGray.cgColor
        postImageView.layer.borderWidth = 1.0
        
        descriptionTextView.delegate = self
        descriptionTextView.text = "Add Description..."
        descriptionTextView.textColor = UIColor.lightGray
        
        self.acceptButton.isHidden = true
        self.declineButton.isHidden = true
        
        if CategoryController.shared.topCategories.isEmpty {
            CategoryController.shared.loadTopLevelCategories { (success) in
                DispatchQueue.main.async {
                    self.category1 = CategoryController.shared.topCategories
                    self.pickerOne.reloadAllComponents()
                    self.category1Selected = CategoryController.shared.topCategories.last
                }
            }
        } else {
            self.category1 = CategoryController.shared.topCategories
        }
        
        showTheRightButtons()
        updateViews()
        createCameraButton()
        setButtonTitle()
        setBorders()
        
        //        // Notifications to move view up or down when the keyboard it shown or hidden.
                NotificationCenter.default.addObserver(self, selector: #selector(CreateAndSuggestViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//                NotificationCenter.default.addObserver(self, selector: #selector(CreateAndSuggestViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        addDoneButtonOnKeyboard()
        addDoneButtonOnPicker()
    }
    
    // MARK: - Actions
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        
        guard let revisedPost = revisedPost, let post = post else { return }

        let alert = UIAlertController(title: "ACCEPT this post suggestion?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            RevisedPostController.shared.acceptRevisedPost(revisedPost: revisedPost, for: post) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func declineButtonTapped(_ sender: Any) {
        
        guard let revisedPost = revisedPost else { return }
        
        let alert = UIAlertController(title: "DECLINE this post suggestion?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            RevisedPostController.shared.declineRevisedPost(revisedPost: revisedPost, completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
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
    
    
    // MARK: - Tool Bar
    
    func addDoneButtonOnPicker() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 32))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CreateAndSuggestViewController.doneButtonAction))
        done.tintColor = UIColor.white
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items

        doneToolbar.barTintColor = UIColor(red: 29/255, green: 169/255, blue: 162/255, alpha: 1)
        mainCategoryLabel.inputAccessoryView = doneToolbar
        
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 32))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CreateAndSuggestViewController.doneButtonAction))
        done.tintColor = UIColor.black
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        
        descriptionTextView.inputAccessoryView = doneToolbar
    }
   
    @objc func doneButtonAction() {
        
        descriptionTextView.resignFirstResponder()
        mainCategoryLabel.resignFirstResponder()
    }
    
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
    
    func showTheRightButtons() {
        
        if revisedPost != nil {
            self.createOrSuggestOutlet.isHidden = true
            self.acceptButton.isHidden = false
            self.declineButton.isHidden = false
            
            RevisedPostController.shared.fetchPostForRevisedPost(revisedPost: revisedPost!) { (post) in
                self.post = post
            }
        }
    }
    
    func setButtonTitle() {
        
        if post != nil {
            self.createOrSuggestOutlet.setTitle("Suggest change", for: .normal)
        } else {
            self.createOrSuggestOutlet.setTitle("Create new post", for: .normal)
        }
    }
    
    func updateViews() {
        
        if revisedPost != nil {
            
            placeholderImageView.image = nil
            self.postImageView.image = revisedPost?.image
            self.descriptionTextView.text = revisedPost?.description
            
        } else {
            
            guard let post = post else { return }
            placeholderImageView.image = nil
            self.postImageView.image = post.image
            self.descriptionTextView.text = post.description
        }
    }
    
    func createCameraButton() {
        
        if postImageView.image == nil {
            
            let button: UIButton = UIButton(type: UIButtonType.custom)
            
            button.setImage(#imageLiteral(resourceName: "screenshot-100"), for: .normal)
            button.addTarget(self, action: #selector(showCameraOrLibrary), for: .touchUpInside)
            let navButton = UIBarButtonItem(customView: button)
            self.navigationItem.rightBarButtonItem = navButton
        }
    }
    
    @objc func showCameraOrLibrary() {
        
        DispatchQueue.global(qos: .background).async {
            self.picker.delegate = self
        }
    
        showActionSheet()
    }
    
    // Code to move the view up when the keyboard is shown
    
    @objc func keyboardWillShow(notification: NSNotification) {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 310, right: 0)

    }
//    // Code to move the view down when the keyboard is hidden
//    @objc func keyboardWillHide(notification: NSNotification) {
////        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
////            if self.view.frame.origin.y != 0{
////                self.view.frame.origin.y += keyboardSize.height
////            }
////        }
////        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
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
        placeholderImageView.image = nil
        postImageView.contentMode = .scaleAspectFit
        postImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: - Categories Picker Methods

extension CreateAndSuggestViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return category1.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return category1[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        category1Selected = category1[row]
        mainCategoryLabel.text = category1[row].title.uppercased()
//        self.view.endEditing(true)
        print("Category1:",category1[row].title)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = category1[row].title
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
}
