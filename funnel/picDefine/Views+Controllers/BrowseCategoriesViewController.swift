//
//  BrowseCategoriesViewController.swift
//  funnel
//
//  Created by Alec Osborne on 5/21/18.
//  Copyright © 2018 Rodrigo Sagebin. All rights reserved.
//

import UIKit

class BrowseCategoriesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var pickerOne: UIPickerView!
    //    @IBOutlet weak var pickerTwo: UIPickerView!
    //    @IBOutlet weak var pickerThree: UIPickerView!
    @IBOutlet weak var mainCategoryLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let nib = UINib.init(nibName: "DetailCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DetailCell")
        // EXPLANATION: "red label" at the top is hidden to avoid redundancy
        self.mainCategoryLabel.isHidden = true
        // Initial check to get the top level categories from CK and reloading the picker with the given array
        
        if CategoryController.shared.topCategories.isEmpty {
            CategoryController.shared.loadTopLevelCategories { (success) in
                DispatchQueue.main.async {
                    self.category = CategoryController.shared.topCategories
                    self.pickerOne.reloadAllComponents()
                }
            }
        }
        else {
            self.category = CategoryController.shared.topCategories
        }
    }
    
    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            newCategoryAlert()
            print("left swipe")
        }
    }
    
    func newCategoryAlert() {
        let alert = UIAlertController(title: "This above all else:",
                                      message: "to thine own self be...",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "True",
                                         style: UIAlertActionStyle.cancel,
                                         handler: nil)
        
        alert.addAction(cancelAction)
        
        let createAction = UIAlertAction(title: "Squirrel!", style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addAction(createAction)
        
        alert.addTextField { (alertTextFieldOne: UITextField) -> Void in
            alertTextFieldOne.placeholder = "I like waffles..."
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // EXPLANATION: instance of the categories
    var category = CategoryController.shared.topCategories
    //    let subCategory = CategoryController.shared.category2Categories
    //    let subSubCategory = CategoryController.shared.category3Categories
    
    // EXPLANATION: reference to the picker's selected category as selected array (not a string)
    var selectedCategory: Category1?
    
    // MARK: - Actions
    @IBAction func searchCategoryTapped(_ sender: Any) {
        PostController.shared.fetchPostsFor(category1: selectedCategory!) { (success) in
            if success {
                DispatchQueue.main.async {
                    // EXPLANATION: the table view below is reloaded and then the mainLabel(red) appears above while the "Category Find" cell becomes hidden.
                    self.tableView.reloadData()
                    self.categoryView.isHidden = true
                    self.mainCategoryLabel.isHidden = false
                }
            } else {
                print("Category one fetch failed in the View Controller")
            }
        }
    }
    
    // EXPLANATION: Top button "Find Category" will reanimate the "find" cell and drop the TVC below it.
    @IBAction func findCategoryButtonTapped(_ sender: Any) {
        categoryView.isHidden = false
        self.mainCategoryLabel.isHidden = true
    }
}


// MARK: - Picker extension
extension BrowseCategoriesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let countRows : Int = category.count
        
        // EXPLANATION: Picker Two and Three methods not currently implemented
        //        if pickerView == pickerTwo {
        //            countRows = self.subCategory.count
        //        }
        //        else if pickerView == pickerThree {
        //            countRows = self.subSubCategory.count
        //        }
        return countRows
    }
    
    // EXPLANATION: Functions necessary to conform to the picker method along with string interpolation from the selected category to be shown
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == pickerOne {
//            let labelOne = "\(category[row].title)"
//            self.mainCategoryLabel.text = "\(category[row].title)"
//            self.selectedCategory = category[row]
//            // EXPLANATION: labelOne is the selected category array object set as a string
//            return labelOne
//        }
        
        // EXPLANATION: More methods set for Picker Two and Picker Three
        //        else if pickerView == pickerTwo {
        //            let labelTwo = subCategory[row].title
        //            mainCategoryLabel.text = "\(mainCategoryLabel.text!)/\(subCategory[row].title)"
        //            return labelTwo
        //        }
        //
        //        else if pickerView == pickerThree {
        //            let labelThree = subSubCategory[row].title
        //            mainCategoryLabel.text = "\(mainCategoryLabel.text!)/\(subSubCategory[row].title)"
        //            return labelThree
        //        }
        return category[row].title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mainCategoryLabel.text = category[row].title
        self.selectedCategory = category[row]
    }
}

// EXPLANATION: Extension for the Table View Controller portion of the View Controller.
extension BrowseCategoriesViewController: UITableViewDelegate, UITableViewDataSource, CommentsDelegate {
    
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
        //        cell.descriptionTextView.layer.borderColor = UIColor.black.cgColor
        //        cell.descriptionTextView.layer.borderWidth = 1.0
        //        cell.tagsTextView.layer.borderColor = UIColor.black.cgColor
        //        cell.tagsTextView.layer.borderWidth = 1.0
        
        cell.commentsDelegate = self
        
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
        let selectedPost = PostController.shared.feedPosts[indexPath.row]
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
