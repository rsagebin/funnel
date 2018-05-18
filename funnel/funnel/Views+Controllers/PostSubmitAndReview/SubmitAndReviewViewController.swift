//
//  SubmitAndReviewViewController.swift
//  funnel
//
//  Created by Pedro Henrique Chiericatti on 5/14/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import CloudKit

class SubmitAndReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    
    let picker = UIImagePickerController()
    var post: Post?
    var category = ""

    // MARK: - Outlets
    
    @IBOutlet weak var topCategory: UITextField!
    @IBOutlet weak var mediumCategory: UITextField!
    @IBOutlet weak var bottomCategory: UITextField!
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var tagTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createAndSuggestButtonOutlet: UIButton!
    
    // MARK: - Actions
    
    @IBAction func createOrSuggestPostButtonTapped(_ sender: Any) {
        
        guard let image = imageViewOutlet.image, let description = descriptionTextView.text else { return }

        guard let topCategory = topCategory.text, let mediumCategory = mediumCategory.text, let bottomCategory = bottomCategory.text else { return }
        
        if mediumCategory == "" && bottomCategory == "" {
            self.category = topCategory
        } else if bottomCategory == "" {
            self.category = "\(topCategory)/\(mediumCategory)"
        } else {
            self.category = "\(topCategory)/\(mediumCategory)/\(bottomCategory)"
        }
    
//        let newPost = MockPost(description: description, image: image, category: self.category)
        
//        PostController.shared.mockFeedPosts.append(newPost)
        
        PostController.shared.createPost(description: description, image: image, category: category)
        
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
    
    // MARK: - Other functions
    
    func setBorders() {
        
        tagTextView.layer.borderColor = UIColor.lightGray.cgColor
        tagTextView.layer.borderWidth = 1.0
        
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1.0
    }
    
    func setButtonTitle() {
        
        if post != nil {
            self.createAndSuggestButtonOutlet.setTitle("Suggest change", for: .normal)
        } else {
            self.createAndSuggestButtonOutlet.setTitle("Create new post", for: .normal)
        }
    }
    
    func updateViews() {
        guard let post = post else { return }
        self.category = post.category
        self.imageViewOutlet.image = post.image
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
                noCamera()
            }
        }
        
        func noCamera(){
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        guard let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        imageViewOutlet.contentMode = .scaleAspectFit
        imageViewOutlet.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
