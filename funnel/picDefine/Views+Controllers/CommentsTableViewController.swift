//
//  BlankViewController.swift
//  funnel
//
//  Created by Drew Carver on 5/17/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController, UITextViewDelegate {

    var theRefreshControl: UIRefreshControl!
    
    var post: Post? {
        didSet {
            CommentController.shared.postComments.removeAll()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.isEnabled = false
        
        commentTextView.delegate = self
        commentTextView.text = "   Enter comment..."
        commentTextView.textColor = UIColor.lightGray
        
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
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 0.5
        
        containerView.addSubview(self.commentTextView)
        self.commentTextView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(submitButton)
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: submitButton, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 5).isActive = true
        NSLayoutConstraint(item: submitButton, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 0.3, constant: 0).isActive = true

        NSLayoutConstraint(item: self.commentTextView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 12).isActive = true
        NSLayoutConstraint(item: self.commentTextView, attribute: .trailing, relatedBy: .equal, toItem: submitButton, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.commentTextView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: self.commentTextView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: -10).isActive = true
        
        return containerView
    }()
    
    let submitButton: UIButton = {
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Send", for: .normal)
        submitButton.setTitleColor(UIColor(named: "Color"), for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return submitButton
    }()
    
    // MARK: - Comments Text View
    
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        return textView
    }()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        commentTextView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        submitButton.isEnabled = true
        
        if commentTextView.textColor == UIColor.lightGray {
            commentTextView.text = nil
            commentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        submitButton.isEnabled = false
        
        commentTextView.text = "   Enter comment..."
        commentTextView.textColor = UIColor.lightGray
      
    }
    
    @objc func handleSubmit() {
        print("Inserting Comment:", commentTextView.text ?? "")
        guard let comment = commentTextView.text , !comment.isEmpty else { return }
        guard let post = post else { return }
        CommentController.shared.addCommentTo(post: post, text: comment) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        commentTextView.text = ""
        commentTextView.resignFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Refresh comments
    
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
        
        let comment = CommentController.shared.postComments[indexPath.row]
        cell.comment = comment
        
        CommentController.shared.loadUserFor(comment: comment, completion: { (user) in
            DispatchQueue.main.async {
                cell.user = user
            }
        })
        
        return cell
    }
}
