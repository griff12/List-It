//
//  ViewController.swift
//  List It
//
//  Created by Griffin Christenson on 3/29/18.
//  Copyright © 2018 Eye Zone. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
           
            cell.textLabel?.text = item.title
            
            // Ternary Operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
    
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                    print("Error saving done status \(error)")
                }
            }
            
        tableView.reloadData()
        
//      Order Matters Here
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
 
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
    let alert = UIAlertController(title: "Add New List It Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        //What will happen once user clicks the addButton on our UIAlert
        let currentCategory = self.selectedCategory
        
        if currentCategory != nil && textField.text != "" {
            do {
            try self.realm.write {
        let newItem = Item()
            newItem.title = textField.text!
            newItem.done = false
            newItem.dateCreated = Date.init()
            currentCategory?.items.append(newItem)
            }
            } catch {
                print("Error saving new items, \(error)")
            }
        }
        
        self.tableView.reloadData()
    }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        }
    

    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
  }
    
   
    
}

//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    }
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if  searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }
    }

}

