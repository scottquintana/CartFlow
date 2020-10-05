//
//  ViewController.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/3/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit
import CoreData

class ListSelectVC: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let tableView = UITableView()
    var shoppingLists: [ShoppingList] = [].sorted {
        $0.lastUpdate?.compare($1.lastUpdate!) == .orderedDescending
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        loadLists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Your Lists"
      
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        let addButton =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseID)

    }
    
    func loadLists() {
        let request: NSFetchRequest<ShoppingList> = ShoppingList.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "lastUpdate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            shoppingLists = try context.fetch(request)
        } catch {
            print("Error loading your shopping lists")
        }
    }
    
    func saveLists() {
        do {
            try context.save()
        } catch {
            print("Error saving lists: \(error)")
        }
    }
  
    
    @objc func addButtonTapped() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new list", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let action = UIAlertAction(title: "Create new list", style: .default) { action in
            let newListItem = ShoppingList(context: self.context)
            newListItem.name = textField.text ?? "Untitled List"
            newListItem.lastUpdate = Date()
            self.shoppingLists.append(newListItem)
            self.saveLists()
            self.tableView.reloadData()
        }
       
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Name of list"
            textField = alertTextField
        }
        alert.addAction(cancel)
        alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    

}

//MARK: - TableView Extensions

extension ListSelectVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseID) as! ListCell
        
        let shoppingList = shoppingLists[indexPath.row]
        cell.set(shoppingList: shoppingList)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        context.delete(shoppingLists[indexPath.row])
        self.shoppingLists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        self.saveLists()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = shoppingLists[indexPath.row]
        let destVC = CFTabBarController(listSelected: list)
        
        navigationController?.pushViewController(destVC, animated: false)
    }
    
}
