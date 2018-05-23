//
//  ProfileSettingsViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userUsername: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        setUpBorders()
    }

    // MARK: - Actions
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure you want to delete your account?", message: "All your data will be lost", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete Account", style: .destructive, handler: nil)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Other Functions
    
    func setUpBorders() {
    
        userUsername.layer.borderColor = UIColor.black.cgColor
        userUsername.layer.borderWidth = 1.0

        userEmail.layer.borderColor = UIColor.black.cgColor
        userEmail.layer.borderWidth = 1.0
        
        userName.layer.borderColor = UIColor.black.cgColor
        userName.layer.borderWidth = 1.0
    }
    
    func updateView() {
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        userUsername.text = " \(user.username)"
        userName.text = " \(user.name)"
        userEmail.text = " \(user.email)"
    }
}
