//
//  BrowseCategoriesViewController.swift
//  funnel
//
//  Created by Alec Osborne on 5/21/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class BrowseCategoriesViewController: UIViewController {
    
    // MARK: - Properties
    
    var theRefreshControl: UIRefreshControl!
    
    var category1 = CategoryController.shared.topCategories
    
    var selectedCategory: Category1?
    
    // MARK: - Outlets
    
    @IBOutlet weak var pickerOne: UIPickerView!
    @IBOutlet weak var searchCategoryTextField: UITextField!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theRefreshControl = UIRefreshControl()
        theRefreshControl.addTarget(self, action: #selector(didPullForRefresh), for: .valueChanged)
        tableView.addSubview(theRefreshControl)
        
        searchButton.layer.cornerRadius = 5
        
        searchCategoryTextField.inputView = pickerOne
        searchCategoryTextField.delegate = self
        
        pickerOne.dataSource = self
        pickerOne.delegate = self
        
        let nib = UINib.init(nibName: "DetailCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DetailCell")

        // Initial check to get the top level categories from CK and reloading the picker with the given array
        
        if CategoryController.shared.topCategories.isEmpty {
            CategoryController.shared.loadTopLevelCategories { (success) in
                DispatchQueue.main.async {
                    self.category1 = CategoryController.shared.topCategories
                    self.pickerOne.reloadAllComponents()
                }
            }
        }
        else {
            self.category1 = CategoryController.shared.topCategories
        }
    }
    
    // MARK: - Other Functions
    
    func startNetworkActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func endNetworkActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    @objc func didPullForRefresh() {
        
        self.startNetworkActivity()
        self.tableView.reloadData()
        self.theRefreshControl.endRefreshing()
        
        guard let selectedCategory = selectedCategory else { self.endNetworkActivity(); return }
        
        PostController.shared.fetchPostsFor(category1: selectedCategory) { (_) in
            DispatchQueue.main.async {
                self.endNetworkActivity()
            }
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func searchCategoryTapped(_ sender: Any) {

        guard let selectedCategoty = selectedCategory else { return }
        
        PostController.shared.fetchPostsFor(category1: selectedCategoty) { (success) in
            if success {
                DispatchQueue.main.async {
                    // EXPLANATION: the table view below is reloaded and then the mainLabel(red) appears above while the "Category Find" cell becomes hidden.
                    self.tableView.reloadData()
                    self.searchCategoryTextField.resignFirstResponder()
                }
            } else {
                print("Category one fetch failed in the View Controller")
            }
        }
    }
}

// MARK: - Picker extension
extension BrowseCategoriesViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return category1.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return category1[row].title
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.searchCategoryTextField.text = category1[row].title.uppercased()
        self.selectedCategory = category1[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = category1[row].title
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
}

// EXPLANATION: Extension for the Table View Controller portion of the View Controller.
extension BrowseCategoriesViewController: UITableViewDelegate, UITableViewDataSource, CommentsDelegate, SuggestionDelegate {
    func postSuggestionButtonTapped(post: Post) {
        let submitAndReviewSB = UIStoryboard(name: "CreateAndSuggest", bundle: .main)
        let submitAndReviewVC = submitAndReviewSB.instantiateViewController(withIdentifier: "CreateAndSuggestSB") as! CreateAndSuggestViewController
        submitAndReviewVC.post = post
        navigationController?.pushViewController(submitAndReviewVC, animated: true)
    }
    
    @objc func reloadFeedView() {
        DispatchQueue.main.async {
            // EXPLANATION: tableView being reloaded is only functioning within the View Controller because it's being referenced as an outlet.
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.category1Posts.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailViewCell
        
        let post = PostController.shared.category1Posts[indexPath.row]
        cell.post = post
        UserController.shared.fetchUser(ckRecordID: post.creatorRef.recordID) { (user) in
            DispatchQueue.main.async {
                
                cell.user = user
            }
        }
        cell.commentsDelegate = self
        cell.suggestDelegate = self
        return cell
    }
    
    func didTapComment(post: Post) {
        print("Message coming from FeedController")
        print(post.description)
        let commentsSB = UIStoryboard(name: "Comments", bundle: .main)
        let commentsController = commentsSB.instantiateViewController(withIdentifier: "CommentsSB") as! CommentsTableViewController
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mySB = UIStoryboard(name: "PostDetail", bundle: .main)
        let vc = mySB.instantiateViewController(withIdentifier: "PostDetailSB") as! PostDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedPost = PostController.shared.category1Posts[indexPath.row]
        vc.post = selectedPost
        navigationController?.pushViewController(vc, animated: true)
    }
}

// EXPLANATION: Methods placed for search capabilities. Need to create outlets and finish coding on the model+controller to handle the query.

//extension BrowseCategoriesViewController: UISearchBarDelegate {
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        categoryView.isHidden = false
//    }

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let searchTerm = searchBar.text
//        TagController.shared.fetchTagsFor(post: Post) { (searchTerm) in
//            var stringTerm = searchTerm
//        }
//    }
//}
