//
//  LoginViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/15/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets & View Objects
    let backgroundGIFImageView = UIImageView()
    let appLogoView = UIView()
    let appClearView = UIView()
    let appLoginView = UIView()
    let appSignUpView = UIView()
    let appSignedInView = UIView()
    
    let appLogoImageView = UIImageView()
    let appNameLabel = UILabel()
    
    let accountSignUpLabel = UILabel()
    let userNameTextField = UITextField()
    let userUsernameTextField = UITextField()
    let userEmailAddressTextField = UITextField()
    let signUpButton = UIButton()
    
    let signedInLabel = UILabel()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialView()
        fetchUser()
        addDoneButtonOnKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkIfSignedIntoICloud()
    }
    
    
    // MARK: - Methods
    func setupInitialView() {
        
        // Background GIF
        view.addSubview(backgroundGIFImageView)
        backgroundGIFImageView.loadGif(asset: "raining1")
        
        backgroundGIFImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundGIFImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundGIFImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundGIFImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        backgroundGIFImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        
        // Login View
        view.addSubview(appClearView)
        appClearView.backgroundColor = UIColor.white
        appClearView.alpha = 0.75
        appClearView.layer.cornerRadius = 10
        
        appClearView.translatesAutoresizingMaskIntoConstraints = false
        appClearView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70).isActive = true
        appClearView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appClearView.heightAnchor.constraint(equalTo: appClearView.widthAnchor).isActive = true
        appClearView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        
        // App Logo View
        view.addSubview(appLogoView)
        appLogoView.backgroundColor = UIColor.white
        appLogoView.alpha = 0.75
        appLogoView.layer.cornerRadius = 85 // change from hardcode later
        
        appLogoView.translatesAutoresizingMaskIntoConstraints = false
        appLogoView.bottomAnchor.constraint(equalTo: appClearView.topAnchor, constant: -10).isActive = true
        appLogoView.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        appLogoView.heightAnchor.constraint(equalTo: appClearView.heightAnchor, multiplier: 0.6).isActive = true
        appLogoView.widthAnchor.constraint(equalTo: appLogoView.heightAnchor).isActive = true
        
        
        // App Logo Image
        appLogoView.addSubview(appLogoImageView)
        appLogoImageView.image = #imageLiteral(resourceName: "picDefine")
        
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        appLogoImageView.centerYAnchor.constraint(equalTo: appLogoView.centerYAnchor, constant: -5).isActive = true
        appLogoImageView.centerXAnchor.constraint(equalTo: appLogoView.centerXAnchor).isActive = true
        appLogoImageView.heightAnchor.constraint(equalTo: appLogoView.heightAnchor, multiplier: 0.5).isActive = true
        appLogoImageView.widthAnchor.constraint(equalTo: appLogoImageView.heightAnchor, multiplier: 3.75/3).isActive = true
        
        
        // App Name
        appLogoView.addSubview(appNameLabel)
        appNameLabel.text = "picDefine"
        appNameLabel.font = UIFont(name: "arial", size: 26)
        appNameLabel.textAlignment = .center
        appNameLabel.textColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
        
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.centerYAnchor.constraint(equalTo: appLogoView.centerYAnchor, constant: 42).isActive = true
        appNameLabel.centerXAnchor.constraint(equalTo: appLogoView.centerXAnchor).isActive = true
        appNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        appNameLabel.widthAnchor.constraint(equalTo: appLogoView.widthAnchor, multiplier: 0.75).isActive = true
    }
    
    func setupSignUpView() {
        appClearView.backgroundColor = UIColor.clear
        appClearView.alpha = 1
        
        // Sign Up View
        appClearView.addSubview(appSignUpView)
        appSignUpView.backgroundColor = UIColor.white
        appSignUpView.alpha = 0.75
        appSignUpView.layer.cornerRadius = 10
        
        appSignUpView.translatesAutoresizingMaskIntoConstraints = false
        appSignUpView.centerYAnchor.constraint(equalTo: appClearView.centerYAnchor).isActive = true
        appSignUpView.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        appSignUpView.heightAnchor.constraint(equalTo: appClearView.heightAnchor).isActive = true
        appSignUpView.widthAnchor.constraint(equalTo: appClearView.widthAnchor).isActive = true
        
        
        // Sign Up Label
        appClearView.addSubview(accountSignUpLabel)
        accountSignUpLabel.text = "ACCOUNT SIGN UP"
        accountSignUpLabel.font = UIFont(name: "arial", size: 15)
        accountSignUpLabel.textAlignment = .center
        accountSignUpLabel.textColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
        
        accountSignUpLabel.translatesAutoresizingMaskIntoConstraints = false
        accountSignUpLabel.topAnchor.constraint(equalTo: appSignUpView.topAnchor, constant: 15).isActive = true
        accountSignUpLabel.centerXAnchor.constraint(equalTo: appSignUpView.centerXAnchor).isActive = true
        accountSignUpLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        accountSignUpLabel.widthAnchor.constraint(equalTo: appSignUpView.widthAnchor).isActive = true
        
        
        // Name Text Field
        appClearView.addSubview(userNameTextField)
        userNameTextField.placeholder = "Name"
        userNameTextField.font = UIFont(name: "arial", size: 14)
        userNameTextField.backgroundColor = UIColor.white
        userNameTextField.borderStyle = .roundedRect
        
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.topAnchor.constraint(equalTo: accountSignUpLabel.bottomAnchor, constant: 15).isActive = true
        userNameTextField.centerXAnchor.constraint(equalTo: appSignUpView.centerXAnchor).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: appSignUpView.widthAnchor, multiplier: 0.8).isActive = true
        
        
        // Username TextField
        appClearView.addSubview(userUsernameTextField)
        userUsernameTextField.placeholder = "Username"
        userUsernameTextField.backgroundColor = UIColor.white
        userUsernameTextField.font = UIFont(name: "arial", size: 14)
        userUsernameTextField.borderStyle = .roundedRect
        
        userUsernameTextField.translatesAutoresizingMaskIntoConstraints = false
        userUsernameTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 15).isActive = true
        userUsernameTextField.centerXAnchor.constraint(equalTo: appSignUpView.centerXAnchor).isActive = true
        userUsernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userUsernameTextField.widthAnchor.constraint(equalTo: appSignUpView.widthAnchor, multiplier: 0.8).isActive = true
        
        
        // Email Address Text Field
        appClearView.addSubview(userEmailAddressTextField)
        userEmailAddressTextField.placeholder = "Email Address"
        userEmailAddressTextField.font = UIFont(name: "arial", size: 14)
        userEmailAddressTextField.borderStyle = .roundedRect
        
        userEmailAddressTextField.translatesAutoresizingMaskIntoConstraints = false
        userEmailAddressTextField.topAnchor.constraint(equalTo: userUsernameTextField.bottomAnchor, constant: 15).isActive = true
        userEmailAddressTextField.centerXAnchor.constraint(equalTo: appSignUpView.centerXAnchor).isActive = true
        userEmailAddressTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userEmailAddressTextField.widthAnchor.constraint(equalTo: appSignUpView.widthAnchor, multiplier: 0.8).isActive = true
        
        
        // Sign Up Button
        appClearView.addSubview(signUpButton)
        signUpButton.setTitle("Register", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "arial", size: 15)
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.backgroundColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
        signUpButton.layer.cornerRadius = 5
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.topAnchor.constraint(equalTo: userEmailAddressTextField.bottomAnchor, constant: 15).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: appSignUpView.centerXAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: appSignUpView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func showSignedIn() {
        
        appClearView.backgroundColor = UIColor.clear
        appClearView.alpha = 1
        
        // Signed In View
        appClearView.addSubview(appSignedInView)
        appSignedInView.backgroundColor = UIColor.white
        appSignedInView.alpha = 0.75
        appSignedInView.layer.cornerRadius = 10
        
        appSignedInView.translatesAutoresizingMaskIntoConstraints = false
        appSignedInView.centerYAnchor.constraint(equalTo: appClearView.centerYAnchor).isActive = true
        appSignedInView.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        appSignedInView.heightAnchor.constraint(equalTo: appClearView.heightAnchor).isActive = true
        appSignedInView.widthAnchor.constraint(equalTo: appClearView.widthAnchor).isActive = true
        
        
        // Signed In Label
        appSignedInView.addSubview(signedInLabel)
        signedInLabel.text = "Signed in"
        signedInLabel.font = UIFont(name: "arial", size: 20)
        signedInLabel.textColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
        signedInLabel.textAlignment = .center
        
        signedInLabel.translatesAutoresizingMaskIntoConstraints = false
        signedInLabel.centerYAnchor.constraint(equalTo: appSignedInView.centerYAnchor).isActive = true
        signedInLabel.centerXAnchor.constraint(equalTo: appSignedInView.centerXAnchor).isActive = true
        signedInLabel.heightAnchor.constraint(equalTo: appSignedInView.heightAnchor).isActive = true
        signedInLabel.widthAnchor.constraint(equalTo: appSignedInView.widthAnchor).isActive = true
    }
    
    func checkIfSignedIntoICloud() { // Not working properly
        startNetworkActivity()
        if FileManager.default.ubiquityIdentityToken != nil {
            print("User signed into iCloud")
            self.endNetworkActivity()
        } else {
            print("User not signed into iCloud")
            self.endNetworkActivity()
            let alertController = UIAlertController(title: "Not Signed into iCloud", message: "You need to be signed into iCloud in order to use the app", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
                guard let settingsURL = URL(string: "App-Prefs:root") else { return }

                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, completionHandler: nil)
                }
            }

            alertController.addAction(dismissAction)
            alertController.addAction(settingsAction)
            present(alertController, animated: true)
        }
    }

    func checkIfBanned() {
        // Change back to initial
        
        startNetworkActivity()
        guard let user = UserController.shared.loggedInUser else { return }
        if user.isBanned == true {

            let alertController = UIAlertController(title: "You have been banned!", message: "Due to your interaction with the community, you have had three strikes", preferredStyle: .alert)

            let dismissAction = UIAlertAction(title: "I'm the worst", style: .cancel, handler: nil)

            alertController.addAction(dismissAction)
            present(alertController, animated: true)
        }
        self.endNetworkActivity()
    }
    
    func startNetworkActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func endNetworkActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func fetchUser() {
        self.startNetworkActivity()
        
        UserController.shared.fetchCurrentUser { (success) in
            DispatchQueue.main.async {

                // Show Signed In
                if success {
                    self.endNetworkActivity()
                    self.showSignedIn()
                    print("User fetched successfully")

                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { // Change back to 2
                        self.performSegue(withIdentifier: "fromLoginVCToMainVC", sender: nil)
                    })
                }

                // Show Sign Up
                if !success {
                    print("Not able to fetch user")
                    self.endNetworkActivity()
                    self.setupSignUpView()
//                    self.checkIfBanned()
                }
            }
        }
    }
    
    func couldNotFetchUser() {
        let alertcontroller = UIAlertController(title: "User Error", message: "Could not create user, please check your network connection and try again", preferredStyle: .alert)
        
        let dismissButton = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let settingsButton = UIAlertAction(title: "Settings", style: .default) { (_) in
            
            guard let settingsURL = URL(string: "App-Prefs:root") else { return }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, completionHandler: nil)
            }
        }
        
        alertcontroller.addAction(dismissButton)
        alertcontroller.addAction(settingsButton)
        present(alertcontroller, animated: true)
    }
    
    
//     MARK: - Actions
    @objc func signUpButtonPressed() {
        if signUpButton.isEnabled {
            
            guard let username = userUsernameTextField.text, !username.isEmpty,
                let name = userNameTextField.text, !name.isEmpty,
                let email = userEmailAddressTextField.text, !email.isEmpty
                else { return }
            
            startNetworkActivity()
            
            UserController.shared.createNewUserWith(username: username, name: name, email: email) { (success) in
                
                // Segue to Main
                if success {
                    self.endNetworkActivity()
                    self.showSignedIn()
                    
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
    }
    
    
    // MARK: - ToolBar
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LoginViewController.doneButtonAction))
        done.tintColor = UIColor.black
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        
        userUsernameTextField.inputAccessoryView = doneToolbar
        userNameTextField.inputAccessoryView = doneToolbar
        userEmailAddressTextField.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction() {
        
        userUsernameTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        userEmailAddressTextField.resignFirstResponder()
    }
}
