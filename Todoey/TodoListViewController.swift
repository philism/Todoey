//
//  TodoListViewController
//  Todoey
//
//  Created by Phil Smith on 7/2/18.
//  Copyright © 2018 Philip Smith. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
  
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
  
}

