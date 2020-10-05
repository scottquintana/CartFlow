//
//  StoreSelectionVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/25/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

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
    let storePicker = UIPickerView()
    
    weak var delegate: StoreSelectionViewDelegate! 
    
    var selectedStore: GroceryStore? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadStores()
        layoutUI()
        configureStorePicker()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureStorePicker() {
        storePicker.delegate = self
        storePicker.dataSource = self
        storePicker.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    func loadStores() {
        let request: NSFetchRequest<GroceryStore> = GroceryStore.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error loading stores \(error)")
        }
        
        do {
            stores = try context.fetch(request)
        } catch {
            print("Error loading stores \(error)")
        }
        
        
        storePicker.reloadAllComponents()
        
        
    }
    
    func setLocationToEdit(aisle: Aisle) {
        if let store = aisle.parentStore{
            if let storeIndex = stores.firstIndex(of: store) {
            storePicker.selectRow(storeIndex, inComponent: 0, animated: false)
            }
            delegate.didUpdateStore(selectedStore: store)
        }
        
       
        
    }
    
    
    private func layoutUI() {
        addSubview(storesLabel)
        addSubview(addButton)
        addSubview(editButton)
        
        addSubview(storePicker)
        
        storePicker.setValue(UIColor.black, forKey: "textColor")
        storesLabel.text = "Stores:"
        
        addButton.addTarget(self, action: #selector(addNewStore), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editStorePressed), for: .touchUpInside)
        
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            storesLabel.topAnchor.constraint(equalTo: self.topAnchor),
            storesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            storesLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor),
            storesLabel.heightAnchor.constraint(equalToConstant: 26),
            
            addButton.centerYAnchor.constraint(equalTo: storesLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -padding),
            addButton.widthAnchor.constraint(equalToConstant: 26),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            
            
            editButton.centerYAnchor.constraint(equalTo: storesLabel.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            editButton.widthAnchor.constraint(equalToConstant: 26),
            editButton.heightAnchor.constraint(equalTo: editButton.widthAnchor),
            
            storePicker.topAnchor.constraint(equalTo: storesLabel.bottomAnchor, constant: padding),
            storePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            storePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            storePicker.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setSelectedStore() {
        if stores.count > 0 {
            pickerView(storePicker, didSelectRow: 0, inComponent: 0)
        }
    }
    
    
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

extension StoreSelectionView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStore = stores[row]
        
        if selectedStore != nil {
        
            delegate?.didUpdateStore(selectedStore: selectedStore!)
            
        }
    }
    
}

extension StoreSelectionView: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadStores()
    }
}
