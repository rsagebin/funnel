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
    
    @IBOutlet weak var backOfImageView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userUsername: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        backOfImageView.layer.cornerRadius = backOfImageView.frame.size.width / 2
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 9.0
        userImageView.layer.borderColor = UIColor(named: "Color")?.cgColor
        
        setUpBorders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateView()
    }

    // MARK: - Actions
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure you want to delete your account?", message: "All of your data will be lost.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete Account", style: .destructive, handler: { action in
            UserController.shared.deleteCurrentUser(completion: { (success) in
                if success {
                    DispatchQueue.main.async {
                        let vc = LoginViewController()
                        self.present(vc, animated: true, completion: nil)
//                        self.userName = nil
//                        self.userUsername = nil
//                        self.userEmail = nil
                    }

                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error Deleting Account", message: "There was an error deleting your account.", preferredStyle: .alert)
                        let okay = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okay)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
            
        })
        
        
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Other Functions
    
    func setUpBorders() {
    
        userUsername.layer.borderColor = UIColor.lightGray.cgColor
        userUsername.layer.cornerRadius = 3
        userUsername.layer.borderWidth = 1.0

        userEmail.layer.borderColor = UIColor.lightGray.cgColor
        userEmail.layer.cornerRadius = 3
        userEmail.layer.borderWidth = 1.0
        
        userName.layer.borderColor = UIColor.lightGray.cgColor
        userName.layer.cornerRadius = 3
        userName.layer.borderWidth = 1.0
        
        deleteButton.layer.cornerRadius = 3
    }
    
    func updateView() {
        
        guard let user = UserController.shared.loggedInUser else { return }
        
        userUsername.text = " \(user.username)"
        userName.text = " \(user.name)"
        userEmail.text = " \(user.email)"
    }
}
