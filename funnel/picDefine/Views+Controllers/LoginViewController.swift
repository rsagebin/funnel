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
    let appClearView = UIView()
    let appAlphaView = UIView()
    let appLoginView = UIView()
    
    let appNameLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView()
    
    let accountSignUpLabel = UILabel()
    let userNameTextField = UITextField()
    let userUsernameTextField = UITextField()
    let userEmailAddressTextField = UITextField()
    let signUpButton = UIButton()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        addDoneButtonOnKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupInitialView()
        setupClearView()
        checkIfSignedIntoICloud()
    }
    
    
    // MARK: - Methods
    func setupInitialView() {
        
        // Background GIF
        view.addSubview(backgroundGIFImageView)
        backgroundGIFImageView.loadGif(asset: "raining1")
        
        backgroundGIFImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundGIFImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundGIFImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundGIFImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundGIFImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
        // Alpha View
        view.addSubview(appAlphaView)
        appAlphaView.backgroundColor = UIColor.white
        appAlphaView.alpha = 0.75
        appAlphaView.layer.cornerRadius = 10
        
        appAlphaView.translatesAutoresizingMaskIntoConstraints = false
        appAlphaView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        appAlphaView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appAlphaView.heightAnchor.constraint(equalTo: appAlphaView.widthAnchor, multiplier: 1.2).isActive = true
        appAlphaView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    func setupClearView() {
        
        // Clear View
        view.addSubview(appClearView)
        appClearView.backgroundColor = UIColor.clear
        appClearView.layer.cornerRadius = 10
        
        appClearView.translatesAutoresizingMaskIntoConstraints = false
        appClearView.centerYAnchor.constraint(equalTo: appAlphaView.centerYAnchor).isActive = true
        appClearView.centerXAnchor.constraint(equalTo: appAlphaView.centerXAnchor).isActive = true
        appClearView.heightAnchor.constraint(equalTo: appAlphaView.widthAnchor).isActive = true
        appClearView.widthAnchor.constraint(equalTo: appAlphaView.widthAnchor).isActive = true
        
        
        // App Name
        appClearView.addSubview(appNameLabel)
        appNameLabel.text = "picDefine"
        appNameLabel.font = UIFont(name: "Raleway-Regular", size: 42)
        appNameLabel.textAlignment = .center
        appNameLabel.textColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
        
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.centerYAnchor.constraint(equalTo: appClearView.centerYAnchor, constant: -20).isActive = true
        appNameLabel.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        appNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        appNameLabel.widthAnchor.constraint(equalTo: appClearView.widthAnchor, multiplier: 0.75).isActive = true
        
        
        // Activity Indicator
        appClearView.addSubview(activityIndicator)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.topAnchor.constraint(equalTo: appClearView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: appClearView.widthAnchor, multiplier: 0.2).isActive = true
    }
    
    func showSignUpView() {
        activityIndicator.stopAnimating()
        
        
        // Sign Up Label
        appClearView.addSubview(accountSignUpLabel)
        accountSignUpLabel.text = "ACCOUNT SIGN UP"
        accountSignUpLabel.font = UIFont(name: "Raleway-Regular", size: 15)
        accountSignUpLabel.textAlignment = .center
        accountSignUpLabel.textColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
        accountSignUpLabel.alpha = 0
        
        accountSignUpLabel.translatesAutoresizingMaskIntoConstraints = false
        accountSignUpLabel.topAnchor.constraint(equalTo: appClearView.topAnchor, constant: 50).isActive = true
        accountSignUpLabel.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        accountSignUpLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        accountSignUpLabel.widthAnchor.constraint(equalTo: appClearView.widthAnchor).isActive = true
        
        
        // Name Text Field
        appClearView.addSubview(userNameTextField)
        userNameTextField.placeholder = "Name"
        userNameTextField.font = UIFont(name: "Raleway-Regular", size: 14)
        userNameTextField.backgroundColor = UIColor.white
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.alpha = 0
        userNameTextField.isEnabled = false
        
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.topAnchor.constraint(equalTo: accountSignUpLabel.bottomAnchor, constant: 5).isActive = true
        userNameTextField.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: appClearView.widthAnchor, multiplier: 0.8).isActive = true
        
        
        // Username TextField
        appClearView.addSubview(userUsernameTextField)
        userUsernameTextField.placeholder = "Username"
        userUsernameTextField.backgroundColor = UIColor.white
        userUsernameTextField.font = UIFont(name: "Raleway-Regular", size: 14)
        userUsernameTextField.borderStyle = .roundedRect
        userUsernameTextField.alpha = 0
        userUsernameTextField.isEnabled = false
        
        userUsernameTextField.translatesAutoresizingMaskIntoConstraints = false
        userUsernameTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 10).isActive = true
        userUsernameTextField.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        userUsernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userUsernameTextField.widthAnchor.constraint(equalTo: appClearView.widthAnchor, multiplier: 0.8).isActive = true
        
        
        // Email Address Text Field
        appClearView.addSubview(userEmailAddressTextField)
        userEmailAddressTextField.placeholder = "Email Address"
        userEmailAddressTextField.font = UIFont(name: "Raleway-Regular", size: 14)
        userEmailAddressTextField.borderStyle = .roundedRect
        userEmailAddressTextField.alpha = 0
        userEmailAddressTextField.isEnabled = false
        
        userEmailAddressTextField.translatesAutoresizingMaskIntoConstraints = false
        userEmailAddressTextField.topAnchor.constraint(equalTo: userUsernameTextField.bottomAnchor, constant: 10).isActive = true
        userEmailAddressTextField.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        userEmailAddressTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userEmailAddressTextField.widthAnchor.constraint(equalTo: appClearView.widthAnchor, multiplier: 0.8).isActive = true
        
        
        // Sign Up Button
        appClearView.addSubview(signUpButton)
        signUpButton.setTitle("Register", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Raleway-Regular", size: 15)
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.backgroundColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
        signUpButton.layer.cornerRadius = 5
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        signUpButton.alpha = 0
        signUpButton.isEnabled = false
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.topAnchor.constraint(equalTo: userEmailAddressTextField.bottomAnchor, constant: 15).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: appClearView.widthAnchor, multiplier: 0.8).isActive = true
        
        animateSignUp()
    }
    
    func showSignedIn() {
        
        // App Name
        appClearView.addSubview(appNameLabel)
        appNameLabel.text = "picDefine"
        appNameLabel.font = UIFont(name: "Raleway-Regular", size: 42)
        appNameLabel.textAlignment = .center
        appNameLabel.textColor = #colorLiteral(red: 0.08600000292, green: 0.6269999743, blue: 0.5220000148, alpha: 1)
        
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.centerYAnchor.constraint(equalTo: appClearView.centerYAnchor).isActive = true
        appNameLabel.centerXAnchor.constraint(equalTo: appClearView.centerXAnchor).isActive = true
        appNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        appNameLabel.widthAnchor.constraint(equalTo: appClearView.widthAnchor, multiplier: 0.75).isActive = true
        
        
    }
    
    func animateSignUp() {
        activityIndicator.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {
            let y = (self.appNameLabel.frame.height - (self.appNameLabel.frame.height) * 2.9)
            self.appNameLabel.transform = CGAffineTransform(translationX: 0, y: y)
        }) { (success) in
            UIView.animate(withDuration: 1, animations: {
                self.accountSignUpLabel.alpha = 1
                self.userNameTextField.alpha = 1
                self.userNameTextField.isEnabled = true
                self.userUsernameTextField.alpha = 1
                self.userUsernameTextField.isEnabled = true
                self.userEmailAddressTextField.alpha = 1
                self.userEmailAddressTextField.isEnabled = true
                self.signUpButton.alpha = 1
                self.signUpButton.isEnabled = true
            })
        }
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
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                
                // Show Sign Up
                if !success {
                    print("Not able to fetch user")
                    self.endNetworkActivity()
                    self.showSignUpView()
//                    self.checkIfBanned()
                }

                // Show Signed In
                if success {
                    self.endNetworkActivity()
                    self.showSignedIn()
                    print("User fetched successfully")

                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { // Change back to 2
                        self.performSegue(withIdentifier: "fromLoginVCToMainVC", sender: nil)
                    })
                }
            })
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
                
                // Present Alert Controller
                if !success {
//                    self.couldNotFetchUser()
    // Remove later
                    DispatchQueue.main.async {
                        self.endNetworkActivity()
                    }
                }
                    
                    // Show Signed In
                if success {
                    self.endNetworkActivity()
                    
                    UIView.animate(withDuration: 1, animations: {
                        
                        self.accountSignUpLabel.alpha = 0
                        self.userNameTextField.alpha = 0
                        self.userUsernameTextField.alpha = 0
                        self.userEmailAddressTextField.alpha = 0
                        self.signUpButton.alpha = 0
                        
                    }, completion: { (_) in
                        
                        self.signUpButton.removeFromSuperview()
                        self.userEmailAddressTextField.removeFromSuperview()
                        self.userUsernameTextField.removeFromSuperview()
                        self.userNameTextField.removeFromSuperview()
                        self.accountSignUpLabel.removeFromSuperview()
                        
                        UIView.animate(withDuration: 1, animations: {
                            self.appNameLabel.transform = CGAffineTransform(translationX: 0, y: 10)
                        })
                    })
                    self.appNameLabel.removeFromSuperview()
                    self.showSignedIn()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.performSegue(withIdentifier: "fromLoginVCToMainVC", sender: nil)
                    })
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
