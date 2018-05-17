//
//  LoginViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var funnelAppLoadingView: UIView!
    @IBOutlet weak var funnelTitleView: UIView!
    @IBOutlet weak var funnelTwoLabel: UILabel!
    @IBOutlet weak var funnelThreeLabel: UILabel!
    
    @IBOutlet weak var backgroundGif: UIImageView!
    @IBOutlet weak var userSignedInView: UIView!
    @IBOutlet weak var userSignUpView: UIView!
    @IBOutlet weak var userUsernameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailAddressTextField: UITextField!

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundGif.loadGif(asset: "inception")
        funnelTwoLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        funnelThreeLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        self.funnelAppLoadingView.isHidden = false
        self.funnelTitleView.isHidden = false
        self.userSignUpView.isHidden = true
        self.userSignedInView.isHidden = true
        
        fetchUser()
    }
    
    
    // MARK: - Methods
    func fetchUser() {
        UserController.shared.fetchCurrentUser { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                
                // Show Signed In
                if success {
                    self.funnelAppLoadingView.isHidden = true
                    self.funnelTitleView.isHidden = false
                    self.userSignUpView.isHidden = true
                    self.userSignedInView.isHidden = false
                    
                }
                
                // Show Sign Up
                if !success {
                    self.funnelAppLoadingView.isHidden = true
                    self.funnelTitleView.isHidden = false
                    self.userSignUpView.isHidden = false
                    self.userSignedInView.isHidden = true
                }
            })
        }
    }
    
    func couldNotFetchUser() {
        
        let alertcontroller = UIAlertController(title: "User Error", message: "Could not create user, please check your network connection and try again", preferredStyle: .alert)
        
        let alertDismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertcontroller.addAction(alertDismiss)
        present(alertcontroller, animated: true)
    }
    
    
    // MARK: - Actions
    @IBAction func userSignUpButtonPressed(_ sender: UIButton) {
        guard let username = userUsernameTextField.text, !username.isEmpty,
            let name = userNameTextField.text, !name.isEmpty
//            let email = userEmailAddressTextField.text
            else { return }
        
        
        
        UserController.shared.createNewUserWith(username: username, name: name) { (success) in
            
            // Segue to Main
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "fromLoginVCToMainVC", sender: nil)
                }
            }
            
            // Present Alert Controller
            if !success {
                self.couldNotFetchUser()
            }
        }
    }
    
    
    // Will be deleted later
    @IBAction func LoadButtonPressed(_ sender: UIButton) {
        self.funnelAppLoadingView.isHidden = false
        self.funnelTitleView.isHidden = false
        self.userSignUpView.isHidden = true
        self.userSignedInView.isHidden = true
        
    }
    
    @IBAction func SignUpPressed(_ sender: UIButton) {
        self.funnelAppLoadingView.isHidden = true
        self.funnelTitleView.isHidden = false
        self.userSignUpView.isHidden = false
        self.userSignedInView.isHidden = true
    }
    
    @IBAction func SignInPressed(_ sender: UIButton) {
        self.funnelAppLoadingView.isHidden = true
        self.funnelTitleView.isHidden = false
        self.userSignUpView.isHidden = true
        self.userSignedInView.isHidden = false
    }
    
    //        var emptyUsername = ""
    //        var emptyName = ""
    //        var emptyEmail = ""
    //
    //        if username.isEmpty == true {
    //            emptyUsername = "Username needs to be filled in"
    //        }
    //
    //        if name.isEmpty == true {
    //            emptyName = "Name needs to be filled in"
    //        }
    //
    //        if email.isEmpty == true {
    //            emptyEmail = "Username needs to be filled in"
    //        }
    //
    //        let alertController = UIAlertController(title: "Enter Additional Details", message: "\(emptyUsername) \(emptyName) \(emptyEmail)", preferredStyle: .alert)
    //
    //        let dismissAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    //
    //        alertController.addAction(dismissAlert)
    //
    //        present(alertController, animated: true)
}
