//
//  AddNewItemVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/6/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit
import CoreData

protocol AddNewItemVCDelegate: class {
    
    func didAddNewItem(controller: AddNewItemVC, item: ShoppingItem)
}

class AddNewItemVC: UIViewController {
    
    let itemNameView = ItemNameView()
    let itemLocationsView = ItemLocationsView()
    var editingItem: Bool = false
    let itemNameLabel = CFBodyLabel(textAlignment: .left)
    
    
    let itemDescriptionLabel = CFBodyLabel(textAlignment: .left)
    let itemDescriptionTextField = CFTextField()
    let sectionBackgroundColor: UIColor = .systemGray
    
    let itemStoreLabel = CFBodyLabel()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var selectedItem: ShoppingItem? = nil
    var itemLocations: [Aisle] = []
    
    var stores: [GroceryStore] = []
    let locationSelector = LocationSelectionView()
    
    
    var delegate: AddNewItemVCDelegate!
    let padding: CGFloat = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
        
        locationSelector.storeSelection.delegate = self
        locationSelector.aisleSelection.delegate = self
        
        configureCancelButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureItemName()
        configureItemLocations()
        configureLocationSelection()
        
        configureAddButton()
        
        view.backgroundColor = .systemBackground
    }
    
    
    private func configureCancelButton() {
        
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        navigationBar.barTintColor = .systemBackground
        navigationBar.tintColor = .systemBackground
        self.view.addSubview(navigationBar)
        
        let cancelButton =  UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = cancelButton
        cancelButton.tintColor = .label
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    
    private func configureItemName() {
        view.addSubview(itemNameView)
        itemNameView.translatesAutoresizingMaskIntoConstraints = false
        itemNameView.layer.cornerRadius = 20
        itemNameView.backgroundColor = sectionBackgroundColor
        
        itemNameView.itemNameTextField.text = editingItem ? "\(selectedItem!.name!)" : ""
        NSLayoutConstraint.activate([
            itemNameView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            itemNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemNameView.heightAnchor.constraint(equalToConstant: 120)
        
        ])
    }
    
    
    private func configureItemLocations() {
        if selectedItem != nil {
            itemLocations = selectedItem!.itemLocation?.allObjects as! [Aisle]
        }
        
        itemLocationsView.set(itemLocations: itemLocations)
        view.addSubview(itemLocationsView)
        itemLocationsView.translatesAutoresizingMaskIntoConstraints = false
        itemLocationsView.layer.cornerRadius = 20
        itemLocationsView.backgroundColor = sectionBackgroundColor
        
        NSLayoutConstraint.activate([
            itemLocationsView.topAnchor.constraint(equalTo: itemNameView.bottomAnchor, constant: padding),
            itemLocationsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemLocationsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemLocationsView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    
    private func configureLocationSelection() {
        view.addSubview(locationSelector)
        
        locationSelector.translatesAutoresizingMaskIntoConstraints = false
        locationSelector.layer.cornerRadius = 20
        locationSelector.backgroundColor = sectionBackgroundColor
        
        NSLayoutConstraint.activate([
            locationSelector.topAnchor.constraint(equalTo: itemLocationsView.bottomAnchor, constant: padding),
            locationSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            locationSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationSelector.heightAnchor.constraint(equalToConstant: 260)
            
        ])
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureAddButton() {
        let title = editingItem ? "Save Edit" : "Add new item"
        let addButton = CFButton(backgroundColor: .systemBlue, title: title)
        view.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(pushItemListVC), for: .touchUpInside)
        addButton.backgroundColor = Colors.green
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: locationSelector.bottomAnchor, constant: 50),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    
    
    
    
    private func validationAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .destructive, handler: { (action) -> Void in })
        
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc func dismissVC() {
        selectedItem = nil
        itemNameView.itemNameTextField.text = ""
        
        dismiss(animated: true)
    }
    
    @objc func pushItemListVC() {
        
        if itemNameView.itemNameTextField.text == "" {
            validationAlert(message: "You must name the item")
            return
        }
        
        switch editingItem {
        case true:
            selectedItem?.name = itemNameView.itemNameTextField.text
        case false:
            let newItem = ShoppingItem(context: context)
            newItem.name = itemNameView.itemNameTextField.text!
            if let aisleToAdd = locationSelector.aisleSelection.selectedAisle {
                newItem.addToItemLocation(aisleToAdd)
            }
            
        }
        
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        dismissVC()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension AddNewItemVC: AisleSelectionViewDelegate, StoreSelectionViewDelegate {
    func didUpdateStore(selectedStore: GroceryStore) {
        locationSelector.aisleSelection.selectedStore = selectedStore
        locationSelector.aisleSelection.loadAisles()
    }
    
    func presentStoreAlert(alert: UIAlertController) {
        let editItemVC = EditLocationVC()
        editItemVC.selectedStore = locationSelector.storeSelection.selectedStore
        editItemVC.modalPresentationStyle = .overFullScreen
        
        present(editItemVC, animated: false)
    }
    
    func presentAisleAlert(alert: UIAlertController) {
        
      
        let editItemVC = EditLocationVC()
        editItemVC.modalPresentationStyle = .overFullScreen
        
        present(editItemVC, animated: false)
        
    }
    
    
}

