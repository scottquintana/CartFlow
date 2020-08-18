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
    
    let itemNameLabel = CFBodyLabel(textAlignment: .left)
    let itemNameTextField = CFTextField()
    
    let itemDescriptionLabel = CFBodyLabel(textAlignment: .left)
    let itemDescriptionTextField = CFTextField()
    
    let itemStoreLabel = CFBodyLabel()
    let itemStoreTextField = CFTextField()
    let storePicker = UIPickerView()
    let storePlusButton = CFPlusButton()
    
    let itemAisleLabel = CFBodyLabel()
    let itemAisleTextField = CFTextField()
    let aislePicker = UIPickerView()
    let aislePlusButton = CFPlusButton()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let addButton = CFButton(backgroundColor: .systemBlue, title: "Add New Item")
    
    var stores: [GroceryStore] = []
    var aisles: [Aisle] = []
    var selectedStore: GroceryStore? = nil
    var selectedAisle: Aisle? = nil
    
    var delegate: AddNewItemVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(itemNameLabel)
        view.addSubview(itemNameTextField)
        view.addSubview(addButton)
        view.addSubview(itemDescriptionLabel)
        view.addSubview(itemDescriptionTextField)
        view.addSubview(itemStoreLabel)
        view.addSubview(itemStoreTextField)
        view.addSubview(storePlusButton)
        view.addSubview(itemAisleLabel)
        view.addSubview(itemAisleTextField)
        view.addSubview(aislePlusButton)
        
        
        configureItemName()
        configureItemDescription()
        
        configureStoreSelection()
        configureStorePicker()
        configureAisleSelection()
        configureAislePicker()
        
        createAisleToolbar()
        configureCancelButton()
        configureAddButton()
        
        loadStores()
        
        view.backgroundColor = .systemBackground
    }
    
    
    private func configureCancelButton() {
        
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        self.view.addSubview(navigationBar)
        
        let cancelButton =  UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = cancelButton
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    private func configureItemName() {
        
        itemNameLabel.text = "Name: (required)"
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            itemNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            itemNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            itemNameTextField.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: padding),
            itemNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemNameTextField.heightAnchor.constraint(equalToConstant: 36)
            
        ])
    }
    
    
    private func configureItemDescription() {
        
        itemDescriptionLabel.text = "Description of item:"
        
        let padding: CGFloat = 20
        
        
        NSLayoutConstraint.activate([
            itemDescriptionLabel.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: padding),
            itemDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemDescriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            itemDescriptionTextField.topAnchor.constraint(equalTo: itemDescriptionLabel.bottomAnchor, constant: padding),
            itemDescriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemDescriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemDescriptionTextField.heightAnchor.constraint(equalToConstant: 36)
            
        ])
        
    }
    
    func configureStoreSelection() {
        let padding: CGFloat = 20
        
        itemStoreLabel.text = "Store:"
        
        itemStoreTextField.placeholder = "Click to select store"
        
        //storePlusButton.translatesAutoresizingMaskIntoConstraints = false
        
        storePlusButton.addTarget(self, action: #selector(addStorePressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            itemStoreLabel.topAnchor.constraint(equalTo: itemDescriptionTextField.bottomAnchor, constant: padding),
            itemStoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemStoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemStoreLabel.heightAnchor.constraint(equalToConstant: 20),
            
            itemStoreTextField.topAnchor.constraint(equalTo: itemStoreLabel.bottomAnchor, constant: padding),
            itemStoreTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemStoreTextField.trailingAnchor.constraint(equalTo: storePlusButton.leadingAnchor, constant: -5),
            itemStoreTextField.heightAnchor.constraint(equalToConstant: 40),
            
            storePlusButton.centerYAnchor.constraint(equalTo: itemStoreTextField.centerYAnchor),
            storePlusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            storePlusButton.heightAnchor.constraint(equalToConstant: 40),
            storePlusButton.widthAnchor.constraint(equalToConstant: 40)
            
            
        ])
    }
    
    
    func configureStorePicker() {
        storePicker.delegate = self
        storePicker.dataSource = self
        storePicker.tag = 1
        storePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let toolbar =  UIToolbar()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddNewItemVC.dismissKeyboard))
        
        toolbar.setItems([flexButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        
        itemStoreTextField.inputView = storePicker
        itemStoreTextField.inputAccessoryView = toolbar
    }
    
    
    func configureAisleSelection() {
        let padding: CGFloat = 20
        
        itemAisleLabel.text = "Aisle:"
        itemAisleTextField.inputView = aislePicker
        itemAisleTextField.placeholder = "Click to select aisle"
        
        
        aislePlusButton.addTarget(self, action: #selector(addAislePressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            itemAisleLabel.topAnchor.constraint(equalTo: itemStoreTextField.bottomAnchor, constant: padding),
            itemAisleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemAisleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemAisleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            itemAisleTextField.topAnchor.constraint(equalTo: itemAisleLabel.bottomAnchor, constant: padding),
            itemAisleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemAisleTextField.trailingAnchor.constraint(equalTo: aislePlusButton.leadingAnchor, constant: -5),
            itemAisleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            aislePlusButton.centerYAnchor.constraint(equalTo: itemAisleTextField.centerYAnchor),
            aislePlusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            aislePlusButton.heightAnchor.constraint(equalToConstant: 40),
            aislePlusButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureAislePicker() {
        aislePicker.delegate = self
        aislePicker.tag = 2
        aislePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func createAisleToolbar() {
        let toolbar =  UIToolbar()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddNewItemVC.dismissKeyboard))
        
        toolbar.setItems([flexButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        toolbar.sizeToFit()
        itemAisleTextField.inputAccessoryView = toolbar
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureAddButton() {
        addButton.addTarget(self, action: #selector(pushItemListVC), for: .touchUpInside)
        addButton.backgroundColor = Colors.green
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: itemAisleTextField.bottomAnchor, constant: 50),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func addStorePressed() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new grocery store", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let action = UIAlertAction(title: "Add store", style: .default) { (action) in
            let newStore = GroceryStore(context: self.context)
            newStore.name = textField.text!
            do {
                try self.context.save()
            } catch {
                print("Error saving store")
            }
            self.loadStores()
            self.storePicker.reloadAllComponents()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Store name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func addAislePressed() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new aisle", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let action = UIAlertAction(title: "Add aisle", style: .default) { (action) in
            let newAisle = Aisle(context: self.context)
            newAisle.label = textField.text!
            newAisle.parentStore = self.selectedStore
            do {
                try self.context.save()
            } catch {
                print("Error saving aisle")
            }
            self.loadAisles()
            self.aislePicker.reloadAllComponents()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Store name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadStores() {
        let request: NSFetchRequest<GroceryStore> = GroceryStore.fetchRequest()
        
        
        do {
            stores = try context.fetch(request)
        } catch {
            print("Error loading stores \(error)")
        }
    }
    
    
    func loadAisles(){
        let request: NSFetchRequest<Aisle> = Aisle.fetchRequest()
        let predicate = NSPredicate(format: "ANY parentStore.name =[cd] %@", selectedStore!.name!)
        let sortDescriptor = NSSortDescriptor(key: "label", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        do {
            aisles = try context.fetch(request)
        } catch {
            print("Error loading aisles")
        }
        
        self.aislePicker.reloadAllComponents()
        
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
        itemNameTextField.text = ""
    }
    
    @objc func pushItemListVC() {
        
        
        let newItem = ShoppingItem(context: context)
        newItem.name = itemNameTextField.text!
        newItem.addToItemLocation(selectedAisle!)
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        
        // copy above principal connecting aisle to store, 
        
        dismiss(animated: true)
        
        
    }
    
}

extension AddNewItemVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return stores.count
        default:
            return aisles.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return stores[row].name
        default:
            return aisles[row].label
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            selectedStore = stores[row]
            itemStoreTextField.text = selectedStore?.name
            dismissKeyboard()
            loadAisles()
        case 2:
            selectedAisle = aisles[row]
            itemAisleTextField.text = selectedAisle?.label
            dismissKeyboard()
        default:
            dismissKeyboard()
        }
        
    }
}
