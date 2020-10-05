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
    var fetchController: NSFetchedResultsController<ShoppingItem>!
    
    var selectedSectionName: String? = nil
    var currentStore: String? = nil
    let titleButton = CFTitleButton()
    var titlebuttonWidth: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.green
        
        configureTitleView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavItems()
        configureTableView()
        loadItems()
    }
    
    
    init(shoppingList: ShoppingList) {
        super.init(nibName: nil, bundle: nil)
        self.shoppingList = shoppingList
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureTitleView() {
        
        let buttonTitle = currentStore ?? "All items"
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.set(storeName: buttonTitle)
        
        titlebuttonWidth = titleButton.widthAnchor.constraint(equalToConstant: (titleButton.title.intrinsicContentSize.width + titleButton.downArrow.intrinsicContentSize.width))
        titlebuttonWidth.isActive = true
        
        titleButton.addTarget(self, action: #selector(sortLists), for: .touchUpInside)
        
    }
    
    
    func configureNavItems() {
        let clearListButton = UIBarButtonItem(image: SFSymbols.doneCheck, style: .plain, target: self, action: #selector(clearList))
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        self.parent?.navigationItem.titleView = titleButton
        self.parent?.navigationItem.rightBarButtonItem = clearListButton
        self.parent?.navigationItem.searchController = nil
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.bounds
        tableView.rowHeight = 55
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .none
        tableView.sectionIndexBackgroundColor = .black
        tableView.sectionIndexColor = .white
        
        tableView.register(ShoppingListCell.self, forCellReuseIdentifier: ShoppingListCell.reuseID)
    }
    
    
    @objc func clearList() {
        let clearListVC = ClearListVC()
        clearListVC.delegate = self
        clearListVC.modalPresentationStyle = .overFullScreen
        clearListVC.modalTransitionStyle = .crossDissolve
        present(clearListVC, animated: true)
    }
    
    
    @objc func sortLists() {
        let storeFilterVC = StoreFilterVC()
        storeFilterVC.delegate = self
        storeFilterVC.modalPresentationStyle = UIModalPresentationStyle.popover
        storeFilterVC.preferredContentSize = CGSize(width: 200, height: getPopoverHeight())
        if let storePopoverPC = storeFilterVC.popoverPresentationController {
            //storePopoverPC.barButtonItem = filterButton
            storePopoverPC.sourceView = titleButton
            storePopoverPC.sourceRect = titleButton.title.frame
            storePopoverPC.permittedArrowDirections = .up
            
            
            storePopoverPC.delegate = self
            
        }
        
        present(storeFilterVC, animated: true)
        
    }
    
    func getPopoverHeight() -> CGFloat {
        let request: NSFetchRequest<GroceryStore> = GroceryStore.fetchRequest()
        var stores: [GroceryStore] = []
        do {
            stores = try context.fetch(request)
        } catch {
            print("Error")
        }
        
        let height = CGFloat((stores.count * 44) + 60)
        
        if height > 500 {
            return 500
        } else {
            return height
        }
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
                
                // Try to find a solution that isn't O(n2) if possible
                
                for item in items {
                    if let locations = item.itemLocation as? Set<Aisle> {
                        for location in locations {
                            
                            if location.parentStore!.name == currentStore {
                                if let aisle = location.label {
                                    
                                    // Make a model for this that doesn't invole core data?
                                    
                                    let itemCurrentLocation = LocationForStore(context: context)
                                    itemCurrentLocation.aisleNumber = aisle
                                    itemCurrentLocation.storeName = location.parentStore?.name
                                    item.itemLocationInStore = itemCurrentLocation
                                    
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

//MARK: - StoreFilterVCDelegate

extension ShoppingListVC: StoreFilterVCDelegate {
    
    func didResetFilter() {
        currentStore = nil
        selectedSectionName = nil
        titleButton.set(storeName: "All items")
        titlebuttonWidth.constant = (titleButton.title.intrinsicContentSize.width + titleButton.downArrow.intrinsicContentSize.width)
        self.parent?.navigationItem.titleView?.setNeedsLayout()
        self.parent?.navigationItem.titleView?.layoutIfNeeded()
        loadItems()
    }
    
    func didSelectStore(store: GroceryStore) {
        currentStore = store.name
        titleButton.set(storeName: currentStore!)
        titlebuttonWidth.constant = (titleButton.title.intrinsicContentSize.width + titleButton.downArrow.intrinsicContentSize.width)
        self.parent?.navigationItem.titleView?.setNeedsLayout()
        self.parent?.navigationItem.titleView?.layoutIfNeeded()
        
        loadItems()
    }
}

//MARK: - TableView & FetchedResults Extensions

extension ShoppingListVC: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListCell.reuseID, for: indexPath) as! ShoppingListCell
        let item = fetchController.object(at: indexPath)
        cell.selectionStyle = .none
        cell.set(item: item)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let entity = fetchController.object(at: indexPath)
        entity.removeFromParentList(shoppingList)
        
        saveList()
        loadItems()
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let outOfStockAction = UIContextualAction(style: .normal, title: "Out of stock") { (action, view, bool) in
            let item = self.fetchController.object(at: indexPath)
            item.outOfStock = true
            item.inCart = false
            self.saveList()
            self.tableView.reloadData()
        }
        outOfStockAction.backgroundColor = Colors.yellow
        
        return UISwipeActionsConfiguration(actions: [outOfStockAction])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let frc = fetchController {
            return frc.sections!.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = fetchController.object(at: indexPath)
        entity.inCart = !entity.inCart
        if entity.inCart {
            entity.outOfStock = false
        }
        
        saveList()
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionInfo = fetchController?.sections?[section] else { return nil }
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = Colors.green
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 25))
        label.text = sectionInfo.name
        label.textColor = .black
        returnedView.addSubview(label)
        
        return returnedView
    }
}

//MARK: - UIPopoverPresentationControllerDelegate

extension ShoppingListVC: UIPopoverPresentationControllerDelegate {
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

//MARK: - ClearListVCDelegate

extension ShoppingListVC: ClearListVCDelegate {
    func didFinishShopping() {
        if let items = fetchController.fetchedObjects {
            for item in items {
                if item.inCart {
                    item.lastPurchased = Date()
                    item.inCart = false
                    item.removeFromParentList(shoppingList)
                }
            }
            saveList()
            loadItems()
            updateTabBarBadge()
        }
    }
    
    
    func didClearCart() {
        if let items = fetchController.fetchedObjects {
            for item in items {
                item.inCart = false
                item.outOfStock = false
                item.itemLocationInStore = nil
                item.removeFromParentList(shoppingList)
            }
            saveList()
            loadItems()
            updateTabBarBadge()
        }
    }
    
    
    func updateTabBarBadge() {
        if shoppingList!.items!.count > 0 {
            self.tabBarController?.tabBar.items![0].badgeValue = String(shoppingList!.items!.count)
        } else {
            self.tabBarController?.tabBar.items![0].badgeValue = nil
        }
    }
}
