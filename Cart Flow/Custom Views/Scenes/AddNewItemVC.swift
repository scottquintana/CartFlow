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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let itemNameView = ItemNameView()
    let itemLocationsView = ItemLocationsView()
    var itemLocationsHeight: NSLayoutConstraint!

    let sectionBackgroundColor: UIColor = .white
    
    var selectedItem: ShoppingItem? = nil
    
    var itemLocations: [Aisle] = []
    let locationSelector = LocationSelectionView()
    var locationSelectorHeight: NSLayoutConstraint!
    
    var isEditingLocation = false
    var isAddingLocation = false
    var editingItem = false
   
    weak var delegate: AddNewItemVCDelegate!
    
    let padding: CGFloat = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTapGestures()
        configureDelegates()
        configureCancelButton()
        configureItemName()
        configureItemLocations()
        configureLocationSelection()
        configureAddButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = Colors.green
    }
    
    
    private func configureTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.isUserInteractionEnabled = true
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    private func configureDelegates() {
        itemLocationsView.delegate = self
        locationSelector.delegate = self
        locationSelector.storeSelection.delegate = self
        locationSelector.aisleSelection.delegate = self
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
    
    
    private func loadLocations() {
        if selectedItem != nil {
            itemLocations = selectedItem!.itemLocation?.allObjects as! [Aisle]
        }
        
        itemLocationsView.set(itemLocations: itemLocations)
    }
    
    
    private func configureItemLocations() {
        loadLocations()
        view.addSubview(itemLocationsView)
        
        itemLocationsView.translatesAutoresizingMaskIntoConstraints = false
        itemLocationsView.layer.cornerRadius = 16
        itemLocationsView.layer.masksToBounds = true
        itemLocationsView.backgroundColor = sectionBackgroundColor
        itemLocationsHeight = itemLocationsView.heightAnchor.constraint(equalToConstant: 136)
        itemLocationsHeight.isActive = true
        
        NSLayoutConstraint.activate([
            itemLocationsView.topAnchor.constraint(equalTo: itemNameView.bottomAnchor, constant: padding),
            itemLocationsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemLocationsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
    
    
    private func toggleLocations() {
        isEditingLocation = !isEditingLocation
        itemLocationsHeight.constant = isEditingLocation ? 190 : 136
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: { self.view.layoutIfNeeded() })
    }
    
    
    private func configureLocationSelection() {
        view.addSubview(locationSelector)
        locationSelector.layer.masksToBounds = true
        locationSelector.translatesAutoresizingMaskIntoConstraints = false
        locationSelector.layer.cornerRadius = 16
        locationSelector.backgroundColor = sectionBackgroundColor
        locationSelectorHeight = locationSelector.heightAnchor.constraint(equalToConstant: 40)
        locationSelectorHeight.isActive = true
        
        NSLayoutConstraint.activate([
            locationSelector.topAnchor.constraint(equalTo: itemLocationsView.bottomAnchor, constant: padding),
            locationSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            locationSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
    
    
    func toggleLocationSelection() {
        isAddingLocation = !isAddingLocation
        locationSelectorHeight.constant = isAddingLocation ? 300 : 40
        locationSelector.storeSelection.setSelectedStore()
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: { self.view.layoutIfNeeded() })
    }
    

    func configureAddButton() {
        let title = editingItem ? "Save Edit" : "Add new item"
        let addButton = CFButton(backgroundColor: .systemBlue, title: title)
        view.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(pushItemListVC), for: .touchUpInside)
        addButton.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: locationSelector.bottomAnchor, constant: 20),
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
        editingItem = false
        itemNameView.itemNameTextField.text = ""
        
        dismiss(animated: true)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

//MARK: - LocationSelectionViewDelegate

extension AddNewItemVC: LocationSelectionViewDelegate {
    func didPressRemoveLocation(aisleToRemove: Aisle) {
         selectedItem?.removeFromItemLocation(aisleToRemove)
         
         do {
             try context.save()
         } catch {
             print("Error removing location. \(error)")
         }
         loadLocations()
         toggleLocations()
     }
}

//MARK: - AisleSelectionViewDelegate

extension AddNewItemVC: AisleSelectionViewDelegate {
    func presentAisleAlert(alert: UIAlertController) {
        let editItemVC = EditLocationVC()
        editItemVC.modalPresentationStyle = .overFullScreen
        
        present(editItemVC, animated: false)
    }
}

//MARK: - StoreSelectionViewDelegate

extension AddNewItemVC: StoreSelectionViewDelegate {
    func didPressAddStore(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    
    func didUpdateStore(selectedStore: GroceryStore) {
        locationSelector.aisleSelection.selectedStore = selectedStore
        locationSelector.aisleSelection.loadAisles()
    }
    
    func didPressEditStore() {
        let editItemVC = EditLocationVC()
        editItemVC.selectedStore = locationSelector.storeSelection.selectedStore

        
        editItemVC.modalPresentationStyle = .overFullScreen
        editItemVC.isEditingStore = true
        present(editItemVC, animated: false)
    }
}

//MARK: - ItemLocationsViewDelegate

extension AddNewItemVC: ItemLocationsViewDelegate {
    func didPressEditLocation() {
        toggleLocations()
    }
    
    
    func addToLocationsButtonPressed() {
        if !editingItem {
            let newItem = ShoppingItem(context: context)
            newItem.name = itemNameView.itemNameTextField.text!
            
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
            }
            
            selectedItem = newItem
            editingItem = true
        }
        
        
        if let aisle = locationSelector.aisleSelection.selectedAisle {
            selectedItem?.addToItemLocation(aisle)
            
            do {
                try context.save()
            } catch {
                print("Error adding aisle. \(error)")
            }
            loadLocations()
            toggleLocationSelection()
            }
    }
    
    
    func didToggleLocationSelection() {
        toggleLocationSelection()
    }
}

