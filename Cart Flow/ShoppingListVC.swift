//
//  ShoppingListVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/3/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class ShoppingListVC: UIViewController {
    
    var shoppingList: ShoppingList!
    var tableView = UITableView()
    let itemListVC = ItemListVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavItems()
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
        
    }
    
}



