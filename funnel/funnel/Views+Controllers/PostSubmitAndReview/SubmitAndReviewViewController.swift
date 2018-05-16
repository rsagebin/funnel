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

//    let user = User(username: "Pedro", name: "PedroChiericatti", userRef: nil)

    // MARK: - Outlets
    
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    
    @IBOutlet weak var tagTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Actions
    
    @IBAction func ImageButtonTapped(_ sender: Any) {
        showActionSheet()
    }
    @IBAction func createOrSuggestPostButtonTapped(_ sender: Any) {
        
        
//        let newPost = Post(user: self.user , description: descriptionTextView.text, image: imageViewOutlet.image!, creatorRef: CKReference(record: user.ckRecord, action: .deleteSelf))
//        PostController.shared.mockFeedPosts.append(newPost)
        
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        tagTextView.layer.borderColor = UIColor.lightGray.cgColor
        tagTextView.layer.borderWidth = 1.0
        
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        
        createCameraButton()
        
        
    }
    
    // MARK: - Other functions
    
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
    
    @IBAction func imageButtonTapped(_ sender: UIButton) {
       showActionSheet()
    }
    
    func showActionSheet() {
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            // show camera
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = true
            
//                 self.picker.navigationItem.rightBarButtonItem = self.editButtonItem
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
//            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
//            self.picker.popoverPresentationController?.sourceRect = self
            
        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(takePhoto)
        actionSheet.addAction(goToLibrary)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//
//        picker.setEditing(editing, animated: animated)
//    }
    
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
