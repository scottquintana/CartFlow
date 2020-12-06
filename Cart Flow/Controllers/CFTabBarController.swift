//
//  CFTabBarController.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/3/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class CFTabBarController: UITabBarController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var shoppingList: ShoppingList!
    
    init(listSelected: ShoppingList) {
        self.shoppingList = listSelected
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [createListsVC(), createItemListVC()]
        tabBar.barTintColor = .systemBackground
        tabBar.tintColor = .label
        tabBar.items![0].badgeColor = Colors.red
        
        configureNotifications()
        updateBadge()

    }
    
 
    func createListsVC() -> UIViewController {
        let shoppingListVC = ShoppingListVC(shoppingList: shoppingList)
        shoppingListVC.title = "Shopping List"
        shoppingListVC.tabBarItem = UITabBarItem(title: "Shopping List", image: SFSymbols.cart, tag: 0)

        return shoppingListVC
    }
    
    
    func createItemListVC() -> UIViewController {
        let itemListVC = ItemListVC()
        itemListVC.title = "Item list"
        itemListVC.selectedList = shoppingList
        itemListVC.tabBarItem = UITabBarItem(title: "Items List", image: SFSymbols.list, tag: 1)
        
        return itemListVC
    }
    
    
    private func configureNotifications() {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                             name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                             object: context)
    }
    
    
    private func updateBadge() {
        if shoppingList.items!.count > 0 {
            tabBar.items![0].badgeValue = String(shoppingList!.items!.count)
        } else {
            tabBar.items![0].badgeValue = nil
        }
    }
    
    
    @objc func managedObjectContextObjectsDidChange(_ notification: Notification){
        updateBadge()
    }
    
}
