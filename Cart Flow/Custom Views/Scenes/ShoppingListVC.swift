//
//  ShoppingListVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/3/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var shoppingList: ShoppingList!
    var tableView = UITableView()
    let itemListVC = ItemListVC()
    var listItems: [ShoppingItem] = []
    var fetchController: NSFetchedResultsController<ShoppingItem>!
    var selectedSectionName: String? = nil
    var currentStore: String? = "Publix"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.lightBar
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        configureNavItems()
        configureTableView()
        loadItems()
    }
    
    
    init(shoppingList: ShoppingList) {
        super.init(nibName: nil, bundle: nil)
        self.shoppingList = shoppingList
        
        print(shoppingList.name!)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureNavItems() {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        self.parent?.title = shoppingList.name
        self.parent?.navigationItem.rightBarButtonItem = nil
        self.parent?.navigationItem.searchController = nil
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 55
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray5
        
        tableView.register(ShoppingListCell.self, forCellReuseIdentifier: ShoppingListCell.reuseID)
    }
    
    func loadItems() {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        
        let predicate1 = NSPredicate(format: "ANY parentList.name =[cd] %@", shoppingList!.name!)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate1
        
        if currentStore != nil {
            do {
                let items = try context.fetch(request)
                
                for item in items {
                    if let locations = item.itemLocation as? Set<Aisle> {
                        for location in locations {
                            print("\(item.name!): \(location.label!) at: \(location.parentStore!.name!)")
                            if location.parentStore!.name == currentStore {
                                print("hi")
                                
                                if let aisle = location.label {
                                    
                                    let itemCurrentLocation = LocationForStore(context: context)
                                    itemCurrentLocation.aisleNumber = aisle
                                    itemCurrentLocation.storeName = location.parentStore?.name
                                    item.itemLocationInStore = itemCurrentLocation
                                    print("Here: \(item.itemLocationInStore?.aisleNumber)")
                                }
                            }
                        }
                    }
                    
                    saveList()
                    
                }
            } catch {
                print(error)
            }
            
            selectedSectionName = "itemLocationInStore.aisleNumber"
            let sortDescriptor2 = NSSortDescriptor(key: "itemLocationInStore.aisleNumber", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
            let predicate2 = NSPredicate(format: "ANY itemLocationInStore.storeName =[cd] %@", currentStore!)
            let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
            request.predicate = combinedPredicate
            request.sortDescriptors = [sortDescriptor2, sortDescriptor]
        }
        
        fetchController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: selectedSectionName, cacheName: nil)
        
        do {
            try fetchController.performFetch()
        } catch {
            print("Error loading this list")
        }
        
        tableView.reloadData()
    }
    
    
    func saveList() {
        do {
            try context.save()
        } catch {
            print("Error saving list")
        }
    }
}

//MARK: - Extensions


extension ShoppingListVC: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListCell.reuseID, for: indexPath) as! ShoppingListCell
        let entity = fetchController.object(at: indexPath)
        cell.itemLabel.text = entity.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let entity = fetchController.object(at: indexPath)
        entity.removeFromParentList(shoppingList)
        
        saveList()
        loadItems()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchController?.sections?[section] else {
            return "Add Items"
        }
        
        let title = sectionInfo.name
        
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let frc = fetchController {
            return frc.sections!.count
            
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = fetchController.object(at: indexPath)
        print(entity.itemLocationInStore?.aisleNumber)
    }
    
    
    
    
}


