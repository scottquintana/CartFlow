//
//  EditLocationVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/31/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit
import CoreData

protocol EditLocationVCDelegate: class {
    func didEditLocation()
    
    func didCancelEdit()
}

class EditLocationVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let storeTextField = CFTextField()
    let editContainer = UIView()
    let aisleContainer = UIView()
    let editAislesView = EditAislesView()
    let aislesTableView = UITableView()
    let stackView = UIStackView()
    let padding: CGFloat = 8
    
    var selectedStore: GroceryStore?
    
    var aislesInStore: [Aisle] = []
    
    weak var delegate: EditLocationVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        
        editAislesView.delegate = self
        configureEditContainer()
        configureStore()
        configureAisleContainer()
        configureAisle()
        configureAislesTableView()
        configureButtons()
        
        if selectedStore != nil {
            loadAisles()
        }
    }
    
    
    func setStore(store: GroceryStore) {
        self.selectedStore = store
        loadAisles()
    }
    
    
    private func configureEditContainer() {
        view.addSubview(editContainer)
        
        editContainer.backgroundColor = .black
        editContainer.layer.cornerRadius = 16
        editContainer.layer.borderWidth = 2
        editContainer.layer.borderColor = UIColor.black.cgColor
        editContainer.layer.shadowColor = UIColor.systemGray.cgColor
        editContainer.layer.shadowOpacity = 0.25
        editContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
        editContainer.layer.shadowRadius = 15
        editContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let topBottomPadding: CGFloat = 100
        let sidePadding: CGFloat = 10
        NSLayoutConstraint.activate([
            editContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: topBottomPadding),
            editContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            editContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            editContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -topBottomPadding)
        ])
    }
    
    
    private func configureStore() {
    
        editContainer.addSubview(storeTextField)
    
        storeTextField.placeholder = "Enter store name"
        storeTextField.text = selectedStore?.name ?? ""
        
        
        NSLayoutConstraint.activate([

            storeTextField.topAnchor.constraint(equalTo: editContainer.topAnchor, constant: 20),
            storeTextField.leadingAnchor.constraint(equalTo: editContainer.leadingAnchor, constant: 20),
            storeTextField.trailingAnchor.constraint(equalTo: editContainer.trailingAnchor, constant: -20),
            storeTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    
    private func configureAisleContainer() {
        editContainer.addSubview(aisleContainer)
        aisleContainer.translatesAutoresizingMaskIntoConstraints = false
        aisleContainer.layer.cornerRadius = 16
        aisleContainer.backgroundColor = .white
        NSLayoutConstraint.activate([
            aisleContainer.topAnchor.constraint(equalTo: storeTextField.bottomAnchor, constant: padding),
            aisleContainer.leadingAnchor.constraint(equalTo: editContainer.leadingAnchor),
            aisleContainer.trailingAnchor.constraint(equalTo: editContainer.trailingAnchor),
            aisleContainer.bottomAnchor.constraint(equalTo: editContainer.bottomAnchor, constant: -58)
            
            // set this height to adjust with the aisle count
            
        ])
        
    }
    
    
    private func configureAisle() {
        aisleContainer.addSubview(editAislesView)
        aisleContainer.addSubview(aislesTableView)
        
        aisleContainer.layer.masksToBounds = true
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
            aislesTableView.leadingAnchor.constraint(equalTo: aisleContainer.leadingAnchor, constant: 4),
            aislesTableView.trailingAnchor.constraint(equalTo: aisleContainer.trailingAnchor, constant: -4),
            aislesTableView.bottomAnchor.constraint(equalTo: aisleContainer.bottomAnchor)
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
        let cancelButton = CFButton()
        let saveButton = CFButton()
        
        editContainer.addSubview(stackView)
        stackView.addArrangedSubview(deleteButton)
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(saveButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        deleteButton.set(backgroundColor: Colors.red, title: "Delete store")
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        cancelButton.set(backgroundColor: .systemGray3, title: "Cancel")
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        saveButton.set(backgroundColor: Colors.green, title: "Save")
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
         //   stackView.topAnchor.constraint(equalTo: aisleContainer.bottomAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: editContainer.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: editContainer.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: editContainer.bottomAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 36),
            
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
            self.delegate.didEditLocation()
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    @objc private func cancelButtonPressed() {
        delegate.didCancelEdit()
    }
    
    
    @objc private func saveButtonPressed() {
        do {
            try context.save()
        } catch {
            print("Error saving.")
        }

        delegate.didEditLocation()
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
