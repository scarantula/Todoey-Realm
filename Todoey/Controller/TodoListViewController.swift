//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeCellViewController {
    
    var filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let realm = try! Realm()
    
    var toDoItems: Results<Item>?
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(filePath)
        
        navigationController?.navigationBar.barTintColor = UIColor.systemBlue
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            
            if let category = self.selectedCategory{
                do{
                    try self.realm.write{
                        let item = Item()
                        item.title = textField.text!
                        item.dateCreated = Date()
                        category.items.append(item)
                    }
                }catch{
                    print("Error saving context \(error).")
                }
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField{
            alertTextField in
            alertTextField.placeholder = "Create new item..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:  Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No To Do Items added yet."
        }
        
        return cell
    }
    
    // MARK:  Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            } catch{
                print("Error while updating done status, \(error).")
            }
        }
        tableView.reloadData()
        //        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        //
        //        save(item: <#T##Item#>)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK:  Data Manipulation Methods
    
    
    
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (self.selectedCategory?.name)!)
        //
        //        if let predicate = predicate {
        //            let resultPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        //            request.predicate = resultPredicate
        //        }
        //        else{
        //            request.predicate = categoryPredicate
        //        }
        //        do{
        //            items = try context.fetch(request)
        //        }catch{
        //            print("Error occured while fetching items.")
        //        }
        tableView.reloadData()
    }
    
    override func update(at indexPath: IndexPath){
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(item)
                }
            }
            catch{
                print("Error deleting the item, \(error).")
            }
        }
        
    }
}


// MARK:  Search bar extension methods

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //
        //        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //
        //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        //        loadItems()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
