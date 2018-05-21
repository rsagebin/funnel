//
//  FeedTableViewCell.swift
//  funnel
//
//  Created by Alec Osborne on 5/16/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

protocol CommentsDelegate {
    func didTapComment()
}

class FeedTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var delegate: CommentsDelegate?
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagsTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var exclamationButtonOutlet: UIButton!
    @IBOutlet weak var commentsButtonOutlet: UIButton!
    
    @IBOutlet weak var branchButtonOutlet: UIButton!
    @IBOutlet weak var aprovedButtonOutlet: UIButton!
   
    // MARK: - Actions
    
    @IBAction func commentsButtonTapped(_ sender: Any) {
        print("Trying to show comments...")
        delegate?.didTapComment()
    }
    
    
    // MARK: - Other Functions
    
    func updateViews() {
        if let post = post {
            self.categoriesLabel.text = post.category
            self.descriptionTextView.text = post.description
            self.postImageView.image = post.image
        }
    }
}
