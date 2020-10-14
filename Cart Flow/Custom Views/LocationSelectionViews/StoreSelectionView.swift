//
//  StoreSelectionVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/25/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//
/*
import UIKit
import CoreData

protocol StoreSelectionViewDelegate: class {
    func didUpdateStore(selectedStore: GroceryStore)
    
    func didPressEditStore()
    
    func didPressAddStore(alert: UIAlertController)
}

class StoreSelectionView: UIView {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let storesLabel = CFSecondaryTitleLabel()
    let addButton = CFPlusButton()
    let editButton = CFEditButton()
    
    var fetchedResultsController: NSFetchedResultsController<GroceryStore>!
    var stores: [GroceryStore] = []
    let storesCollectionView = UICollectionView()
    
    weak var delegate: StoreSelectionViewDelegate! 
    
    var selectedStore: GroceryStore? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(stores: [GroceryStore]) {
        self.stores = stores
        storesCollectionView.reloadData()
    }
    
    
    private func layoutUI() {
        addSubview(storesLabel)
        addSubview(addButton)
        addSubview(storesCollectionView)

        addButton.addTarget(self, action: #selector(addNewStore), for: .touchUpInside)
        
        storesCollectionView.delegate = self
        storesCollectionView.dataSource = self
        storesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        storesCollectionView.allowsMultipleSelection = false
        storesCollectionView.register(StoreCell.self, forCellWithReuseIdentifier: StoreCell.reuseID)
        
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            storesLabel.topAnchor.constraint(equalTo: self.topAnchor),
            storesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            storesLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor),
            storesLabel.heightAnchor.constraint(equalToConstant: 26),
            
            addButton.centerYAnchor.constraint(equalTo: storesLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: storesLabel.leadingAnchor, constant: -padding),
            addButton.widthAnchor.constraint(equalToConstant: 26),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            
            storesCollectionView.topAnchor.constraint(equalTo: storesLabel.bottomAnchor, constant: padding),
            storesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            storesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            storesCollectionView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    

// Move to delegate
    
    @objc func addNewStore() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new store", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newStore = GroceryStore(context: self.context)
            newStore.name = textField.text
            
            do {
                try self.context.save()
            } catch {
                print("error adding store")
                self.context.delete(newStore)
            }
            
            self.loadStores()
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Store name"
            textField = alertTextField
        }
        alert.addAction(cancel)
        alert.addAction(action)
        
        delegate.didPressAddStore(alert: alert)
    }
    
    
    @objc func editStorePressed() {
        if selectedStore != nil {
            delegate.didPressEditStore()
        }
        
    }
    
    
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving aisle")
        }
    }
}

//MARK: - Extensions

extension StoreSelectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCell.reuseID, for: indexPath) as! StoreCell
        cell.set(location: stores[indexPath.row])
    }
    
    
}
*/
