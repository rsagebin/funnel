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
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 3.0
        userImageView.layer.borderColor = UIColor(red: 29/255, green: 169/255, blue: 162/255, alpha: 1).cgColor
        
    }

    func updateUser() {
        guard let user = user  else { return }
         self.usernameLabel.text = user.username


    }
    
    

}
