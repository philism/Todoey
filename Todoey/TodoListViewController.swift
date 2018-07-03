//
//  TodoListViewController
//  Todoey
//
//  Created by Phil Smith on 7/2/18.
//  Copyright © 2018 Philip Smith. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
  }
  
  // MARK: TableView Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print("selected \(itemArray[indexPath.row])")
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    } else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // MARK: Add New Items
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the Add Item button UI Alert
      if let newItem = textField.text {
        if !newItem.isEmpty {
          self.itemArray.append(newItem)
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

