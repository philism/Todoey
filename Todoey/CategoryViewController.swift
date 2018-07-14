//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Phil Smith on 7/13/18.
//  Copyright © 2018 Philip Smith. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

  var categories = [Category]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
      super.viewDidLoad()
      loadCategories()
  }

  // MARK: TableView Datasource Methods
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    let category = categories[indexPath.row]
    cell.textLabel?.text = category.name
    return cell
  }
  
  // MARK: TableView Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let category = categories[indexPath.row]
    print("Selected \(category.name ?? "Unknown")")
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories[indexPath.row]
    }
  }
  
  // MARK: Data Manipulation Methods
  func saveCategories(){
    do {
      try context.save()
    } catch {
      print("Failed to save categories \(error)")
    }
    tableView.reloadData()
  }
  
  func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    do {
      categories = try context.fetch(request)
    } catch {
      print("error loading categories: \(error)")
    }
    tableView.reloadData()
  }
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      if let categoryName = textField.text {
        if !categoryName.isEmpty {
          let category = Category(context: self.context)
          category.name = categoryName
          self.categories.append(category)
          self.saveCategories()
        }
      }
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new category"
      textField = alertTextField
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }

}
