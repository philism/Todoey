//
//  TodoListViewController
//  Todoey
//
//  Created by Phil Smith on 7/2/18.
//  Copyright © 2018 Philip Smith. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
  var itemArray = [Item]()
  var selectedCategory : Category? {
    didSet {
      loadItems()
    }
  }
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    self.tableView.reloadData()
  }
  
  // MARK: TableView Datasource Methods
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    cell.accessoryType = item.done ? .checkmark : .none
    return cell
  }
  
  // MARK: TableView Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//    let itemToDelete = itemArray.remove(at: indexPath.row)
//    context.delete(itemToDelete)
    saveItems()
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // MARK: Add New Items
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the Add Item button UI Alert
      if let itemTitle = textField.text {
        if !itemTitle.isEmpty {
          let newItem = Item(context: self.context)
          newItem.title = itemTitle
          newItem.done = false
          newItem.parentCategory = self.selectedCategory
          self.itemArray.append(newItem)
          self.saveItems()
          self.tableView.reloadData()
        }
      }
    }
    
    alert.addTextField(configurationHandler: { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    })
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: Model Manipulation Methods
  
  func saveItems() {
    do {
      try context.save()
    } catch {
      print("error saving context \(error)")
    }
    self.tableView.reloadData()
  }
  
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    if let additionalPredicate = predicate {
      let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
      request.predicate = compoundPredicate
    } else {
      request.predicate = categoryPredicate
    }

    do {
      itemArray = try context.fetch(request)
    } catch {
      print("error fetching data from context \(error)")
    }
    self.tableView.reloadData()
  }
}

// MARK: Search Bar methods
extension TodoListViewController : UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let request : NSFetchRequest<Item> = Item.fetchRequest()
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    loadItems(with: request, predicate: predicate)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    }
  }
}

