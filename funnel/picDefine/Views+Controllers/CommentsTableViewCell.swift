//
//  CommentsTableViewCell.swift
//  funnel
//
//  Created by Pedro Henrique Chiericatti on 5/21/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
            updateUser()
        }
    }
    
    var comment: Comment? {
        didSet {
            updateViews()
        }
    }

//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//    }
    

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    func updateViews() {
        guard let comment = comment else { return }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.commentLabel.text = comment.text
//        }
    
//        self.layoutIfNeeded()
        
    }

    func updateUser() {
        guard let user = user  else { return }
         self.usernameLabel.text = user.username


    }
    
    

}
