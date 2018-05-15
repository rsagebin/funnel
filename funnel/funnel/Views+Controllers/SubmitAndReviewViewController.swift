//
//  SubmitAndReviewViewController.swift
//  funnel
//
//  Created by Pedro Henrique Chiericatti on 5/14/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class SubmitAndReviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        showActionSheet()
    }

    func showActionSheet() {
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Take Photo", style: .cancel, handler: nil)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            // show camera
        }
        
        let goToLibrary = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            // take to library
        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(takePhoto)
        actionSheet.addAction(goToLibrary)
        
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
