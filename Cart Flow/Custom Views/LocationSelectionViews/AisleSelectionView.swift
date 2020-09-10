//
//  AisleSelectionVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/25/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit
import CoreData

protocol AisleSelectionViewDelegate: class {
    func presentAisleAlert(alert: UIAlertController)
}

class AisleSelectionView: UIView {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let aislesLabel = CFSecondaryTitleLabel()
    let plusButton = CFPlusButton()
    let minusButton = CFMinusButton()
    
    let aislePicker = UIPickerView()
    
    var aisles: [Aisle] = []
    var selectedStore: GroceryStore? = nil
    var selectedAisle: Aisle? = nil
    
    weak var delegate: AisleSelectionViewDelegate!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAislePicker()
        layoutUI()
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureAislePicker() {
        self.aislePicker.delegate = self
        self.aislePicker.dataSource = self
        
        aislePicker.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func layoutUI() {
        addSubview(aislesLabel)
        addSubview(plusButton)
        addSubview(minusButton)
        addSubview(aislePicker)
        
        aislesLabel.text = "Aisles:"
        plusButton.addTarget(self, action: #selector(addAislePressed), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(removeAislePressed), for: .touchUpInside)
        
        let padding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            aislesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            aislesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            aislesLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor),
            aislesLabel.heightAnchor.constraint(equalToConstant: 26),
            
            plusButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            plusButton.leadingAnchor.constraint(equalTo: aislesLabel.trailingAnchor),
            plusButton.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor),
            
            minusButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            minusButton.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor),
            minusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            aislePicker.topAnchor.constraint(equalTo: aislesLabel.bottomAnchor, constant: padding),
            aislePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            aislePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            aislePicker.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    
    func loadAisles() {
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
    
    @objc func addAislePressed() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new aisle", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let action = UIAlertAction(title: "Add aisle", style: .default) { (action) in
            let newAisle = Aisle(context: self.context)
            newAisle.label = textField.text!
            newAisle.parentStore = self.selectedStore
            
            self.saveItems()
            
            self.loadAisles()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Store name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        delegate.presentAisleAlert(alert: alert)
    }
    
    @objc func removeAislePressed() {
        
        let alert = UIAlertController(title: "Remove Aisle", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        let action = UIAlertAction(title: "Remove", style: .default) { (action) in
            
            
            if self.selectedAisle != nil {
                self.context.delete(self.selectedAisle!)
            }
            
            self.saveItems()
            
            
            self.loadAisles()
            
        }
        
        alert.message = "Are you sure you want to remove this aisle? The items in it will not be deleted, however they will lose their location"
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        delegate.presentAisleAlert(alert: alert)
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

extension AisleSelectionView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aisles.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let label = aisles[row].label!
        
        if let description = aisles[row].desc {
            return "\(label) - \(description)"
        } else {
            return label
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedAisle = aisles[row]
    }
    
    
}
