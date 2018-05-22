//
//  BlankViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/17/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {

    var theRefreshControl: UIRefreshControl!
    
    var post: Post? {
        didSet {
            CommentController.shared.postComments.removeAll()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        guard let post = post else { return }
        CommentController.shared.loadCommentsFor(post: post) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        theRefreshControl = UIRefreshControl()
        theRefreshControl.addTarget(self, action: #selector(didPullForRefresh), for: .valueChanged)
        tableView.addSubview(theRefreshControl)
    }
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .lightGray
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.translatesAutoresizingMaskIntoConstraints = false

        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Send", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint(item: submitButton, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 0.3, constant: 0).isActive = true

        NSLayoutConstraint(item: self.commentTextField, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 12).isActive = true
        NSLayoutConstraint(item: self.commentTextField, attribute: .trailing, relatedBy: .equal, toItem: submitButton, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.commentTextField, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 15).isActive = true

        return containerView
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment..."
        return textField
    }()
    
    @objc func handleSubmit() {
        print("Inserting Comment:", commentTextField.text ?? "")
        guard let comment = commentTextField.text , !comment.isEmpty else { return }
        guard let post = post else { return }
        CommentController.shared.addCommentTo(post: post, text: comment) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        commentTextField.text = ""
        commentTextField.resignFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc func didPullForRefresh() {
        
        guard let post = post else { return }
        CommentController.shared.loadCommentsFor(post: post) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.theRefreshControl.endRefreshing()
                }
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommentController.shared.postComments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        cell.commentLabel.text = " "
        
        let comment = CommentController.shared.postComments[indexPath.row]
        
        CommentController.shared.loadUserFor(comment: comment, completion: { (user) in
            DispatchQueue.main.async {
                cell.comment = comment
                cell.user = user
            }
        })
        
        return cell
        
    }
    



}
