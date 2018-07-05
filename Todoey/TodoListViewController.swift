//
//  TodoListViewController
//  Todoey
//
//  Created by Phil Smith on 7/2/18.
//  Copyright © 2018 Philip Smith. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  let defaults_items_key = "TodoListItemArray"
  var itemArray = [Item]()
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let items = defaults.array(forKey: defaults_items_key) as? [Item] {
      self.itemArray = items
    }

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
    //print("selected \(itemArray[indexPath.row])")
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    tableView.deselectRow(at: indexPath, animated: true)
    //self.defaults.set(self.itemArray, forKey: defaults_items_key)
    tableView.reloadData()
  }
  
  // MARK: Add New Items
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the Add Item button UI Alert
      if let newItem = textField.text {
        if !newItem.isEmpty {
          let item = Item(newItem)
          self.itemArray.append(item)
          //self.defaults.set(self.itemArray, forKey: self.defaults_items_key)
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
  
}

