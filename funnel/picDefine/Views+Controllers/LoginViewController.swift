//
//  LoginViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit
import LocalAuthentication

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
        
        backgroundGif.loadGif(asset: "raining1")
        funnelTwoLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        funnelThreeLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        self.funnelAppLoadingView.isHidden = false
        self.funnelTitleView.isHidden = false
        self.userSignUpView.isHidden = true
        self.userSignedInView.isHidden = true
        
        fetchUser()
    }
    
    // MARK: - Methods
    func couldNotFetchUser() {
        let alertcontroller = UIAlertController(title: "User Error", message: "Could not create user, please check your network connection and try again", preferredStyle: .alert)
        
        let alertDismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertcontroller.addAction(alertDismiss)
        present(alertcontroller, animated: true)
    }
    
    func checkIfBanned() {
        self.funnelAppLoadingView.isHidden = false
        self.funnelTitleView.isHidden = false
        self.userSignUpView.isHidden = true
        self.userSignedInView.isHidden = true
        
        guard let user = UserController.shared.loggedInUser else { return }
        if user.isBanned == true {
            
            let alertController = UIAlertController(title: "You have been banned!", message: "Due to your interaction with the community, you have had three strikes", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "I'm the worst", style: .cancel, handler: nil)
            
            alertController.addAction(dismissAction)
            present(alertController, animated: true)
        }
    }
    
    func fetchUser() {
        UserController.shared.fetchCurrentUser { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: { // Change back to 3
                
                // Show Signed In
                if success {
                    self.funnelAppLoadingView.isHidden = true
                    self.funnelTitleView.isHidden = false
                    self.userSignUpView.isHidden = true
                    self.userSignedInView.isHidden = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { // Change back to 2
                        self.performSegue(withIdentifier: "fromLoginVCToMainVC", sender: nil)
                    })
                }
                
                // Show Sign Up
                if !success {
                    self.funnelAppLoadingView.isHidden = true
                    self.funnelTitleView.isHidden = false
                    self.userSignUpView.isHidden = false
                    self.userSignedInView.isHidden = true
//                    self.checkIfBanned()
                }
            })
        }
    }
    
    // MARK: - Actions
    @IBAction func userSignUpButtonPressed(_ sender: UIButton) {
        guard let username = userUsernameTextField.text, !username.isEmpty,
            let name = userNameTextField.text, !name.isEmpty,
            let email = userEmailAddressTextField.text, !email.isEmpty
            else { return }
        
        UserController.shared.createNewUserWith(username: username, name: name, email: email) { (success) in
            
            // Segue to Main
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.performSegue(withIdentifier: "fromLoginVCToMainVC", sender: nil)
                })
            }
            
            // Present Alert Controller
            if !success {
                self.couldNotFetchUser()
            }
        }
    }
    
    
    
    // MARK: Biometric Authentication
    @IBAction func authenticateButtonTapped(_ sender: Any) {
        let context: LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login with TouchID?", reply: { (wasSuccessful, error) in
                if wasSuccessful {
                    print("Success")
                }
                else {
                    print("Not logged in")
                }
            })
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
}
