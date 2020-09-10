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
    
    func presentStoreAlert(alert: UIAlertController)
}

class StoreSelectionView: UIView {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let storesLabel = CFSecondaryTitleLabel()
    let plusButton = CFPlusButton()
    let minusButton = CFMinusButton()
    
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
        
        
        do {
            stores = try context.fetch(request)
        } catch {
            print("Error loading stores \(error)")
        }
        
        storePicker.reloadAllComponents()
    }
    
    
    private func layoutUI() {
        addSubview(storesLabel)
        addSubview(plusButton)
        addSubview(minusButton)
        addSubview(storePicker)
        
        storesLabel.text = "Stores:"
        plusButton.addTarget(self, action: #selector(addStorePressed), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(removeStorePressed), for: .touchUpInside)
        
        let padding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            storesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            storesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            storesLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor),
            storesLabel.heightAnchor.constraint(equalToConstant: 26),
            
            plusButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            plusButton.leadingAnchor.constraint(equalTo: storesLabel.trailingAnchor),
            plusButton.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor),
            
            minusButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            minusButton.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor),
            minusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            storePicker.topAnchor.constraint(equalTo: storesLabel.bottomAnchor, constant: padding),
            storePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            storePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            storePicker.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setSelectedStore() {
        let row = storePicker.selectedRow(inComponent: 0)
        storePicker.delegate?.pickerView?(storePicker, didSelectRow: row, inComponent: 0)
    }
    
    
    @objc func addStorePressed() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new store", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let action = UIAlertAction(title: "Add store", style: .default) { (action) in
            let newStore = GroceryStore(context: self.context)
            newStore.name = textField.text!
            
            self.saveItems()
            self.loadStores()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Store name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        delegate.presentStoreAlert(alert: alert)
    }
    
    
    @objc func removeStorePressed() {
        guard let selectedStore = selectedStore else { return }
        
        let alert = UIAlertController(title: "Remove store", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let action = UIAlertAction(title: "Remove", style: .default) { (action) in
            
            self.context.delete(selectedStore)
            self.selectedStore = nil
            self.saveItems()
            self.loadStores()
        }
        
        alert.message = "Are you sure you want to remove this store? All of the associated aisles will be removed. The items in those aisles will not be deleted, however they will lose their location"
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        delegate.presentStoreAlert(alert: alert)
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
            
            delegate.didUpdateStore(selectedStore: selectedStore!)
            
        }
    }
    
}
