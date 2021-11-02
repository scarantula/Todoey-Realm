//
//  CategoryViewController.swift
//  Todoey
//
//  Created by user205198 on 10/27/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift



class CategoryViewController: SwipeCellViewController {
    
    let realm = try! Realm()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let category = Category()
            category.name = textField.text!

            self.save(category: category)
            
        }
        alert.addTextField{
            alertTextField in
            alertTextField.placeholder = "Create new category..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK:  Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet."
        return cell
    }
    
    
    // MARK:  Data Manipulation Methods
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        //        let request: NSFetchRequest<Category> = Category.fetchRequest()
        //        do{
        //            categories = try context.fetch(request)
        //        }catch{
        //            print("Error loading the categories array \(error).")
        //        }
        //        tableView.reloadData()
    }
    
    func save(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving the categories array \(error).")
        }
        tableView.reloadData()
    }
    
    override func update(at indexPath: IndexPath){
        if let category = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(category)
                }
            }
            catch{
                print("Error deleting the category row, \(error).")
            }
        }
//        tableView.reloadData()
    }
    
    
    // MARK:  Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}


