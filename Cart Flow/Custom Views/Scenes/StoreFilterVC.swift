//
//  StoreFilterVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 9/24/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit
import CoreData

protocol StoreFilterVCDelegate: class {
    func didSelectStore(store: GroceryStore)
    
    func didResetFilter()
}

class StoreFilterVC: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let storesTableView = UITableView()
    let button = CFButton(backgroundColor: .black, title: "All items")
    var stores: [GroceryStore] = []
    
    weak var delegate: StoreFilterVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        loadStores()
    }
    
    
    private func configure() {
        view.addSubview(storesTableView)
        view.addSubview(button)
       
        storesTableView.translatesAutoresizingMaskIntoConstraints = false
        storesTableView.backgroundColor = .white
        storesTableView.delegate = self
        storesTableView.dataSource = self
        
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 40),
            
            storesTableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            storesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func loadStores() {
        let request: NSFetchRequest<GroceryStore> = GroceryStore.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            stores = try context.fetch(request)
        } catch {
            print("Error loading stores. \(error)")
        }
    }
  
    
    @objc func dismissVC() {
        delegate.didResetFilter()
        dismiss(animated: true)
    }
}

//MARK: - TableView Extensions

extension StoreFilterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = stores[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStore = stores[indexPath.row]
        
        delegate.didSelectStore(store: selectedStore)
        dismiss(animated: true)
    }
}
