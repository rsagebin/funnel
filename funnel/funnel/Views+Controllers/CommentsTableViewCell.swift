//
//  CommentsTableViewCell.swift
//  funnel
//
//  Created by Pedro Henrique Chiericatti on 5/21/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    var user: User?
    
    var comment: Comment? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    func updateViews() {
        
        guard let comment = comment else { return }
        self.commentLabel.text = comment.text
        self.usernameLabel.text = user?.username
        
    }

}
