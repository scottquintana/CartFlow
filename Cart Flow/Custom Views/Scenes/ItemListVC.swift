//
//  ItemListVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/3/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit
import CoreData


class ItemListVC: UIViewController {
    
    class DataSource: UITableViewDiffableDataSource<Section, ShoppingItem> {
        
        let itemListVC = ItemListVC()
        
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    
                    var snapshot = self.snapshot()
                    snapshot.deleteItems([identifierToDelete])
                    apply(snapshot)
                    itemListVC.deleteItem(item: identifierToDelete)
                    itemListVC.saveItems()
                }
            }
        }
    }
    
    enum Section {
        case main
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<ShoppingItem>!
    var selectedList: ShoppingList?
    var tableView = UITableView()
    var dataSource: DataSource!
    
   
    
    var currentSearchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        configureViewController()
        configureTableView()
        configureDataSource()
        loadItems()
        
        updateData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavItems()
        tableView.reloadData()
        
    }
    
    func configureViewController() {
        view.backgroundColor = Colors.darkBar
    }
    
    func configureNavItems() {
        self.parent?.title = "All Items"
        let addButton =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.parent?.navigationItem.rightBarButtonItem = addButton
        
        configureSearchController()
        
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 50
        tableView.delegate = self
        
        tableView.register(ItemListCell.self, forCellReuseIdentifier: ItemListCell.reuseID)
    }
    
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for an item"
        searchController.obscuresBackgroundDuringPresentation = false
        self.parent?.navigationItem.searchController = searchController
    }
    
    
    @objc func addButtonTapped() {
        let addItemVC = AddNewItemVC()
        addItemVC.editingItem = false
        addItemVC.itemLocations = []
        addItemVC.isAddingLocation = true
        
        present(addItemVC, animated: true)
    }
    
    
    func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, shoppingItem) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemListCell.reuseID, for: indexPath) as! ItemListCell
            
            cell.set(item: shoppingItem)
            cell.delegate = self
            
            if (shoppingItem.parentList?.contains(self.selectedList!))! {
                cell.backgroundColor = Colors.green
            } else {
                cell.backgroundColor = .systemGray5
            }
            return cell
        })
    }
    
    
    func addToShoppingList(item: ShoppingItem) {
        if (item.parentList?.contains(self.selectedList!))! {
            item.removeFromParentList(selectedList!)
        } else {
            item.addToParentList(selectedList!)
        }
        saveItems()
        tableView.reloadData()
    }
    
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ShoppingItem>()
        snapshot.appendSections([.main])
        
        snapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    func loadItems() {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        
        if !currentSearchText.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", currentSearchText, currentSearchText)
        }
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            updateData()
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    
    func deleteItem(item: NSManagedObject)
    {
        context.delete(item)
    }
    
    
    func saveItems() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
}



//MARK: - Extensions

extension ItemListVC: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        updateData()
    }
}

extension ItemListVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        addToShoppingList(item: item)

    }
}

extension ItemListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            currentSearchText = ""
            loadItems()
            
            return
            
        }
        currentSearchText = text
        loadItems()
    }
}

extension ItemListVC: ItemListCellDelegate {
    func didTapEditItemButton(for item: ShoppingItem) {
        let addItemVC = AddNewItemVC()
        addItemVC.selectedItem = item
        addItemVC.editingItem = true
        addItemVC.locationSelector.storeSelection.setSelectedStore()
        present(addItemVC, animated: true)
    }
    
    
}


