//
//  CFTabBarController.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/3/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class CFTabBarController: UITabBarController {
    
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
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
        tabBar.items![0].badgeColor = Colors.red
        if shoppingList.items!.count > 0 {
            tabBar.items![0].badgeValue = String(shoppingList!.items!.count)
        }
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
    
}
