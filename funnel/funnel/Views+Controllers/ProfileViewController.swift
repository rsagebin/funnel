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
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
   
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

      setUpBorders()
    }

    // MARK: - Other Functions
    
    func setUpBorders() {
    
        usernameLabel.layer.borderColor = UIColor.black.cgColor
        usernameLabel.layer.borderWidth = 1.0
        
        emailLabel.layer.borderColor = UIColor.black.cgColor
        emailLabel.layer.borderWidth = 1.0
        
        
        
        
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
