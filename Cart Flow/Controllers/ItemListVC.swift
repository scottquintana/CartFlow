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
    var selectedList: ShoppingList!
    var tableView = UITableView()
    var dataSource: DataSource!
    
    var currentSearchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func configureViewController() {
        view.backgroundColor = Colors.darkBar
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureNavItems() {
        let addButton =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.parent?.navigationItem.rightBarButtonItem = addButton
        self.parent?.navigationItem.titleView = nil
        self.parent?.title = "Your items"
        
        configureSearchController()
        
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.register(ItemListCell.self, forCellReuseIdentifier: ItemListCell.reuseID)
    }
    
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for an item"
        searchController.obscuresBackgroundDuringPresentation = false
        self.parent?.navigationItem.searchController = searchController
    }
    

    private func configureDataSource() {
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
    
    
    private func addToShoppingList(item: ShoppingItem) {
        if (item.parentList?.contains(self.selectedList!))! {
            item.inCart = false
            item.outOfStock = false
            item.removeFromParentList(selectedList!)
            
        } else {
            item.inCart = false
            item.addToParentList(selectedList!)
        }
        saveItems()
        tableView.reloadData()
    }
    
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ShoppingItem>()
        snapshot.appendSections([.main])
        
        snapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    private func loadItems() {
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
    
    
    private func deleteItem(item: NSManagedObject)
    {
        context.delete(item)
    }
    
    
    private func saveItems() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    
    @objc func addButtonTapped() {
        let addItemVC = AddNewItemVC()
        addItemVC.editingItem = false
        addItemVC.itemLocations = []
        addItemVC.isAddingLocation = true
        
        present(addItemVC, animated: true)
    }
}




//MARK: - NSFetchedResultsControllerDelegate

extension ItemListVC: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        updateData()
    }
}

//MARK: - TableViewDelegate

extension ItemListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        addToShoppingList(item: item)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if selectedList!.items!.count > 0 {
        self.tabBarController?.tabBar.items![0].badgeValue = String(selectedList!.items!.count)
        } else {
            self.tabBarController?.tabBar.items![0].badgeValue = nil
        }
       
       

    }
}

//MARK: - UISearchResultsUpdating

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

//MARK: - ItemListCellDelegate

extension ItemListVC: ItemListCellDelegate {
    func didTapEditItemButton(for item: ShoppingItem) {
        let addItemVC = AddNewItemVC()
        addItemVC.selectedItem = item
        addItemVC.editingItem = true
        addItemVC.locationSelector.storeSelection.setSelectedStore()
        present(addItemVC, animated: true)
    }
}


