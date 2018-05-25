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
        self.mainCategoryLabel.isHidden = true
        if CategoryController.shared.topCategories.isEmpty {
            CategoryController.shared.loadTopLevelCategories { (success) in
                DispatchQueue.main.async {
                    self.category = CategoryController.shared.topCategories
                    self.pickerOne.reloadAllComponents()
                }
            }
        }
    }
    
    var category = CategoryController.shared.topCategories
    
    let subCategory = CategoryController.shared.category2Categories
    
    let subSubCategory = CategoryController.shared.category3Categories

    var selectedCategory: Category1?

    
    // MARK: - Actions
    @IBAction func searchCategoryTapped(_ sender: Any) {
        PostController.shared.fetchPostsFor(category1: selectedCategory!) { (success) in
            if success {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.mainCategoryLabel.isHidden = false
                self.categoryView.isHidden = true
                }
            } else {
            print("Category one fetch failed in the View Controller")
            }
        }
        
//        func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            categoryView?.isHidden = true
//            tableView?.topAnchor.constraint(equalTo: true, constant: 100.0)
//        }
//        func viewDidAppear(_ animated: Bool) {
//            super.viewDidAppear(animated)
//            UIView.animate(withDuration: 0.1) {
//                self.categoryView.alpha = 0.6
//            }
//        }
        
//        func viewDidDisappear(_ animated: Bool) {
//            super.viewDidDisappear(animated)
//            categoryView?.isHidden = false
//        }
    }
    

    @IBAction func findCategoryButtonTapped(_ sender: Any) {
                categoryView.isHidden = false
        self.mainCategoryLabel.isHidden = true
    }
}

extension BrowseCategoriesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let countRows : Int = category.count
//        if pickerView == pickerTwo {
//            countRows = self.subCategory.count
//        }
//        else if pickerView == pickerThree {
//            countRows = self.subSubCategory.count
//        }
        return countRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerOne {
            let labelOne = "\(category[row].title)"
            self.mainCategoryLabel.text = "\(category[row].title)"
            self.selectedCategory = category[row]
            return labelOne
        }
            
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
        return ""
    }
}

extension BrowseCategoriesViewController: UITableViewDelegate, UITableViewDataSource, CommentsDelegate {
    
    @objc func reloadFeedView() {
        DispatchQueue.main.async {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedTableViewCell
        
        let post = PostController.shared.category1Posts[indexPath.row]
        cell.post = post
        cell.descriptionTextView.layer.borderColor = UIColor.black.cgColor
        cell.descriptionTextView.layer.borderWidth = 1.0
//        cell.tagsTextView.layer.borderColor = UIColor.black.cgColor
//        cell.tagsTextView.layer.borderWidth = 1.0
        
        cell.delegate = self
        
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
