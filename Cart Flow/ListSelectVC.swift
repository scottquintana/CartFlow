//
//  ViewController.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/3/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class ListSelectVC: UIViewController {

    let tableView = UITableView()
    var shoppingLists: [ShoppingList] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Your Lists"
      
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
    
  
    
    @objc func addButtonTapped() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create new list", style: .default) { action in
            let newListItem = ShoppingList(name: textField.text!, lastUpdate: Date())
            self.shoppingLists.append(newListItem)
            
            self.tableView.reloadData()
          
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Name of list"
            textField = alertTextField
        }
            
        alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    

}

extension ListSelectVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseID) as! ListCell
        
        let sortedList = shoppingLists.sorted {
            $0.lastUpdate.compare($1.lastUpdate) == .orderedDescending
        }
        
        let shoppingList = sortedList[indexPath.row]
        cell.set(shoppingList: shoppingList)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.shoppingLists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = shoppingLists[indexPath.row]
        let destVC = CFTabBarController(listSelected: list)
        
        
        
        
        navigationController?.pushViewController(destVC, animated: false)
    }
    
}
