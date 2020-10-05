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
    let aisleDescriptionLabel = CFSecondaryTitleLabel()
    let plusButton = CFPlusButton()
    let minusButton = CFMinusButton()
    
    let aislePicker = UIPickerView()
    
    var aisles: [Aisle] = []
    var selectedStore: GroceryStore? = nil
    var selectedAisle: Aisle? = nil
    var rotationAngle: CGFloat!
    
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
    }
    
    
    private func layoutUI() {
        addSubview(aislesLabel)
        addSubview(aisleDescriptionLabel)
        addSubview(aislePicker)
        
        let padding: CGFloat = 15
        rotationAngle = 90 * (.pi/180)
        
        
        aislesLabel.text = "Aisle:"
        aislesLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        aislePicker.setValue(UIColor.black, forKey: "textColor")
        aislePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        aislePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            aislesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            aislesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            aislesLabel.widthAnchor.constraint(equalToConstant: 55),
            aislesLabel.heightAnchor.constraint(equalToConstant: 26),
            
            aisleDescriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            aisleDescriptionLabel.leadingAnchor.constraint(equalTo: aislesLabel.trailingAnchor, constant: padding),
            aisleDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            aisleDescriptionLabel.heightAnchor.constraint(equalToConstant: 26),
            
            aislePicker.widthAnchor.constraint(equalToConstant: 40),
            aislePicker.heightAnchor.constraint(equalToConstant: 400),
            aislePicker.centerYAnchor.constraint(equalTo: aislesLabel.bottomAnchor, constant: padding),
            aislePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    
    func setLocationToEdit(aisle: Aisle) {
        
        if let aisleToEdit = aisles.firstIndex(of: aisle) {
            print("aisle: \(aisleToEdit)")
            aislePicker.selectRow((aisleToEdit), inComponent: 0, animated: false)
        }
    }
    
    
    func loadAisles() {
        let request: NSFetchRequest<Aisle> = Aisle.fetchRequest()
        let predicate = NSPredicate(format: "ANY parentStore.name =[cd] %@", selectedStore!.name!)
        let sortDescriptor = NSSortDescriptor(key: "label", ascending: false, selector: #selector(NSString.localizedStandardCompare(_:)))
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        do {
            aisles = try context.fetch(request)
        } catch {
            print("Error loading aisles")
        }
        
        self.aislePicker.reloadAllComponents()
        
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
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.transform = CGAffineTransform(rotationAngle: -rotationAngle)
        
        let label = CFSecondaryTitleLabel()
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        label.textAlignment = .center
        label.text = aisles[row].label
        view.addSubview(label)
        
        return view
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if aisles.count > 0 {
            selectedAisle = aisles[row]
            aisleDescriptionLabel.text = selectedAisle?.desc
        }
        
        
    }
}
