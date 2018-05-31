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
    let scrollView = UIScrollView()
    let GIFImageView = UIImageView()
    let appClearView = UIView()
    let appAlphaView = UIView()
    
    let appNameLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView()
    
    let accountSignUpLabel = UILabel()
    let userNameTextField = UITextField()
    let userUsernameTextField = UITextField()
    let userEmailAddressTextField = UITextField()
    let signUpButton = UIButton()
    
    let ralewayFont = "Raleway-Regular"
    let segueIdentifier = "fromLoginVCToMainVC"
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAndSuggestViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupInitialView()
        setupClearView()
//        checkIfSignedIntoICloud()
    }
    
    
    // MARK: - Methods
    func setupInitialView() {
        
        // Scroll View
        scrollView.isScrollEnabled = false
        scrollView.isPagingEnabled = false
        scrollView.alwaysBounceVertical = true
        
        scrollView.frame = view.frame
        scrollView.contentSize = view.bounds.size
        
        
        // Background GIF
        view.addSubview(GIFImageView)
        GIFImageView.loadGif(asset: "raining1")
        
        GIFImageView.frame = self.view.frame
        
        
        // Alpha View
        scrollView.addSubview(appAlphaView)
        appAlphaView.backgroundColor = UIColor.white
        appAlphaView.alpha = 0.75
        appAlphaView.layer.cornerRadius = 10

        appAlphaView.translatesAutoresizingMaskIntoConstraints = false
        appAlphaView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: 25).isActive = true
        appAlphaView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        appAlphaView.heightAnchor.constraint(equalTo: appAlphaView.widthAnchor, multiplier: 1.2).isActive = true
        appAlphaView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7).isActive = true
        
        view.addSubview(scrollView)
    }

    func setupClearView() {

        // Clear View
        scrollView.addSubview(appClearView)
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
        appNameLabel.font = UIFont(name: ralewayFont, size: 42)
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
        activityIndicator.widthAnchor.constraint(equalTo: appClearView.widthAnchor).isActive = true
    }

    func showSignUpView() {
        activityIndicator.stopAnimating()


        // Sign Up Label
        appClearView.addSubview(accountSignUpLabel)
        accountSignUpLabel.text = "ACCOUNT SIGN UP"
        accountSignUpLabel.font = UIFont(name: ralewayFont, size: 15)
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
        userNameTextField.font = UIFont(name: ralewayFont, size: 14)
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
        userUsernameTextField.font = UIFont(name: ralewayFont, size: 14)
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
        userEmailAddressTextField.keyboardType = .emailAddress
        userEmailAddressTextField.font = UIFont(name: ralewayFont, size: 14)
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
        signUpButton.titleLabel?.font = UIFont(name: ralewayFont, size: 15)
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
        appNameLabel.font = UIFont(name: ralewayFont, size: 42)
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

    func checkIfSignedIntoICloud() {
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
        UserController.shared.fetchCurrentUser { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {

                self.startNetworkActivity()
                
                // Show Signed In
                if success {
                    self.endNetworkActivity()
                    self.showSignedIn()
                    print("User fetched successfully")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { // Change back to 2
                        self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
                    })
                }

                // Show Sign Up
                if !success {
                    print("Not able to fetch user")
                    self.endNetworkActivity()
                    self.showSignUpView()
//                    self.checkIfBanned()
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
    
    func termsAndConditions() {
        let alertcontroller = UIAlertController(title: "Terms & Conditions", message: nil, preferredStyle: .alert)
        
        let textView = UITextView()
        let controller = UIViewController()
        
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textView.frame = controller.view.frame
        textView.alpha = 0.25
        textView.text = termsAndConditionsText
        controller.view.addSubview(textView)
        
        alertcontroller.setValue(controller, forKey: "contentViewController")
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertcontroller.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.height * 0.45)
        alertcontroller.view.addConstraint(height)
        
        let declineButton = UIAlertAction(title: "Decline", style: .destructive, handler: nil)
        
        let agreeButton = UIAlertAction(title: "Agree", style: .default) { (_) in
            
            guard let username = self.userUsernameTextField.text, !username.isEmpty,
                let name = self.userNameTextField.text, !name.isEmpty,
                let email = self.userEmailAddressTextField.text?.lowercased(), !email.isEmpty
                else { return }
            
            self.startNetworkActivity()
            
            UserController.shared.createNewUserWith(username: username, name: name, email: email) { (success) in
                DispatchQueue.main.async {
                    
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
                        })
                    }
                    
                    // Present Alert Controller
                    if !success {
                        self.couldNotFetchUser()
                        self.endNetworkActivity()
                    }
                }
            }
        }
        
        alertcontroller.addAction(declineButton)
        alertcontroller.addAction(agreeButton)
        present(alertcontroller, animated: true)
    }


//     MARK: - Actions
    @objc func signUpButtonPressed() {
        if signUpButton.isEnabled {
            
            guard let name = userNameTextField.text else { return }
            
            if name.isEmpty == true {
                let nameAlertController = UIAlertController(title: "Error", message: "Please enter your name", preferredStyle: .alert)
                let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                nameAlertController.addAction(okayButton)
                present(nameAlertController, animated: true)
            }
            
            guard let username = userUsernameTextField.text else { return }
            
            if username.isEmpty == true {
                let usernameAlertController = UIAlertController(title: "Error", message: "Please enter a username", preferredStyle: .alert)
                let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                usernameAlertController.addAction(okayButton)
                present(usernameAlertController, animated: true)
            }
            
            guard let email = userEmailAddressTextField.text else { return }
            
            if email.isValidEmail() == false {
                let emailAlertController = UIAlertController(title: "Error", message: "Please enter a valid email address", preferredStyle: .alert)
                let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                emailAlertController.addAction(okayButton)
                present(emailAlertController, animated: true)
            }
            
            termsAndConditions()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 310, right: 0)
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
    
    let termsAndConditionsText = "picDefine EULA End User License Agreement (\"Agreement\")\n\nLast updated: (May 31, 2018)/n/nPlease read this End User License Agreement (\"Agreement\") carefully before clicking the \"I Agree\" button, downloading or using picDefine (\"Application\").\n\nBy clicking the \"Agree\" button, downloading or using the Application, you are agreeing to be bound by the terms and conditions of this Agreement.\n\nIf you do not agree to the terms of this Agreement, do not click on the \"I Agree\" button and do not download or use the Application.\n\npicDefine grants you a revocable, non exclusive, non transferable, limited license to download, install and use the Application solely for your personal, non commercial purposes strictly in accordance with the terms of this Agreement.\n\nRestrictions\n\nYou agree not to, and you will not permit others to:\n\na) license, sell, rent, lease, assign, distribute, transmit, host, outsource, disclose or otherwise commercially exploit the Application or make the Application available to any third party.\n\nModifications to Application\n\npicDefine reserves the right to modify, suspend or discontinue, temporarily or permanently, the Application or any service to which it connects, with or without notice and without liability to you.\n\nTerm and Termination\n\nThis Agreement shall remain in effect until terminated by you or picDefine. picDefine may, in its sole discretion, at any time and for any or no reason, suspend or terminate this Agreement with or without prior notice.\n\nThis Agreement will terminate immediately, without prior notice from picDefine, in the event that you fail to comply with any provision of this Agreement. You may also terminate this Agreement by deleting the Application and all copies thereof from your mobile device, your desktop, or any other device in which you have logged in and use picDefine.\n\nUpon termination of this Agreement, you shall cease all use of the Application and delete all copies of the Application from your mobile device, your desktop, or any other device in which you have logged in and use picDefine.\n\nSeverability\n\nIf any provision of this Agreement is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.\n\nAmendments to this Agreement picDefine reserves the right, at its sole discretion, to modify or replace this Agreement at any time. If a revision is material we will provide at least 30 (changes this) days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.\n\nContact Information If you have any questions about this Agreement, please contact us at contact@picdefine.com."
}

extension String {
    func isValidEmail() -> Bool {
        let checkString = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return checkString.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
