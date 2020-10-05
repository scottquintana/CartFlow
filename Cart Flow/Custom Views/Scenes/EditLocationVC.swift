//
//  EditLocationVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/31/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit
import CoreData

class EditLocationVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    let storeTextField = CFTextField()
    let aisleContainer = UIView()
    let editAislesView = EditAislesView()
    
    let aislesTableView = UITableView()
    
 
    let cancelButton = CFButton()
    let saveButton = CFButton()
    
    let padding: CGFloat = 20
    
    var selectedStore: GroceryStore?
    
    var aislesInStore: [Aisle] = []

    var isEditingStore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.green
        
        editAislesView.delegate = self
        
        configureStore()
        configureAisleContainer()
        configureAisle()
        configureAislesTableView()
        configureButtons()
        
        if selectedStore != nil {
            loadAisles()
        }
    }
    
    
    private func configureStore() {
        let locationLabel = CFTitleLabel(textAlignment: .left, fontSize: 30)
        
        view.addSubview(locationLabel)
        view.addSubview(storeTextField)
        
        locationLabel.textAlignment = .left
        locationLabel.text = isEditingStore ? "Edit location" : "Add location"
        
        storeTextField.placeholder = "Enter store name"
        storeTextField.text = selectedStore?.name ?? ""
        
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: padding + 40),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationLabel.heightAnchor.constraint(equalToConstant: 30),
            
            storeTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: padding),
            storeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            storeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            storeTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    
    private func configureAisleContainer() {
        view.addSubview(aisleContainer)
        aisleContainer.translatesAutoresizingMaskIntoConstraints = false
        aisleContainer.layer.cornerRadius = 16
        aisleContainer.backgroundColor = .white
        NSLayoutConstraint.activate([
            aisleContainer.topAnchor.constraint(equalTo: storeTextField.bottomAnchor, constant: padding),
            aisleContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            aisleContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            aisleContainer.heightAnchor.constraint(equalToConstant: 400)
            
            // set this height to adjust with the aisle count
            
        ])
        
    }
    
    
    private func configureAisle() {
        aisleContainer.addSubview(editAislesView)
        aisleContainer.addSubview(aislesTableView)
        editAislesView.translatesAutoresizingMaskIntoConstraints = false
        aislesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        editAislesView.layer.cornerRadius = 16
        editAislesView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            editAislesView.topAnchor.constraint(equalTo: aisleContainer.topAnchor),
            editAislesView.leadingAnchor.constraint(equalTo: aisleContainer.leadingAnchor),
            editAislesView.trailingAnchor.constraint(equalTo: aisleContainer.trailingAnchor),
            editAislesView.bottomAnchor.constraint(equalTo: aislesTableView.topAnchor),
            editAislesView.heightAnchor.constraint(equalToConstant: 160),
            
            aislesTableView.topAnchor.constraint(equalTo: editAislesView.bottomAnchor),
            aislesTableView.leadingAnchor.constraint(equalTo: aisleContainer.leadingAnchor),
            aislesTableView.trailingAnchor.constraint(equalTo: aisleContainer.trailingAnchor),
            aislesTableView.bottomAnchor.constraint(equalTo: aisleContainer.bottomAnchor, constant: -16)
        ])
    }
    
    
    private func configureAislesTableView() {
        aislesTableView.delegate = self
        aislesTableView.dataSource = self
        aislesTableView.backgroundColor = .white
        aislesTableView.register(AisleListCell.self, forCellReuseIdentifier: AisleListCell.reuseID)
    }
    
    
    private func loadAisles() {
        let request: NSFetchRequest<Aisle> = Aisle.fetchRequest()
        let predicate = NSPredicate(format: "ANY parentStore.name =[cd] %@", selectedStore!.name!)
        let sortDescriptor = NSSortDescriptor(key: "label",
                                              ascending: true,
                                              selector: #selector(NSString.localizedStandardCompare(_:)))
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        
        do {
            aislesInStore = try context.fetch(request)
        } catch {
            print("Error loading aisles")
        }
        aislesTableView.reloadData()
    }
    
    
    private func configureButtons() {
        let deleteButton = CFButton()
        
        view.addSubview(deleteButton)
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        
        let buttonHeight: CGFloat = 30
        let buttonSpacing: CGFloat = 5
        
        deleteButton.set(backgroundColor: Colors.red, title: "Delete store")
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        if isEditingStore {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
        
        cancelButton.set(backgroundColor: .systemGray5, title: "Cancel")
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        saveButton.set(backgroundColor: .black, title: "Save")
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: aisleContainer.bottomAnchor, constant: padding),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            deleteButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -buttonSpacing),
            deleteButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            cancelButton.topAnchor.constraint(equalTo: aisleContainer.bottomAnchor, constant: padding),
            cancelButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: buttonSpacing),
            cancelButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -buttonSpacing),
            cancelButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            saveButton.topAnchor.constraint(equalTo: aisleContainer.bottomAnchor, constant: padding),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: buttonSpacing),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
            saveButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
    }
    
    
    @objc private func deleteButtonPressed() {
        let alert = UIAlertController(title: "Delete store", message: "Are you sure you want to delete this store? It will be removed from all item locations.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {(action) -> Void in })
        let action = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.context.delete(self.selectedStore!)
            
            do {
                try self.context.save()
            } catch {
                print("error deleting store")
            }
            
            self.dismiss(animated: false)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: false)
    }
    
    
    @objc private func saveButtonPressed() {
        do {
            try context.save()
        } catch {
            print("Error saving.")
        }
        isEditingStore = false
        dismiss(animated: false)
    }
}

//MARK: - TableView Extensions

extension EditLocationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aislesInStore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AisleListCell.reuseID) as! AisleListCell
        let aisle = aislesInStore[indexPath.row]
        cell.set(aisle: aisle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aisle = aislesInStore[indexPath.row]
        editAislesView.loadAisleToEdit(selectedAisle: aisle)
    }
}

//MARK: - EditAisleViewDelegate

extension EditLocationVC: EditAisleViewDelegate {
    func didAddAisle(aisle: Aisle) {
        if selectedStore == nil {
            let newStore = GroceryStore(context: context)
            newStore.name = storeTextField.text
            
            selectedStore = newStore
        }
        selectedStore?.addToAisles(aisle)
        //aislesInStore.append(aisle)
        
        do {
            try context.save()
        } catch {
            print("Error saving.")
        }
        
        loadAisles()
    
    }
    
    
    func didUpdateAisle() {
        do {
            try context.save()
        } catch {
            print("Error saving.")
        }
        loadAisles()
    }
}
