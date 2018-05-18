//
//  PostDetailTableViewController.swift
//  funnel
//
//  Created by Alec Osborne on 5/16/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    // MARK: - Properties
    
    var post: MockPost?
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tagsTextView: UITextView!
    
    @IBOutlet weak var branchButtonOutlet: UIButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        branchButtonOutlet.isEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        tagsTextView.layer.borderColor = UIColor.black.cgColor
        tagsTextView.layer.borderWidth = 1.0
    }
    
    // MARK: - Other functions
    
    func updateViews() {
        
        guard let post = post else { return }
        descriptionTextView.text = post.description
        categoryLabel.text = post.category
        postImageView.image = post.image
    }
  
    // MARK: - Actions

    @IBAction func branchPostButtonTapped(_ sender: Any) {
        print("button is working")
        let mySB = UIStoryboard(name: "PostSubmitAndReview", bundle: .main)
        let vc = mySB.instantiateViewController(withIdentifier: "PostAndSubmitSB") as! SubmitAndReviewViewController
        vc.post = self.post
        navigationController?.pushViewController(vc, animated: true)
    }
}
