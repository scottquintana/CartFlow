//
//  LocationSelectionVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/25/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

protocol LocationSelectionViewDelegate: class {
    func didToggleLocationSelection()
    
    func addToLocationsButtonPressed()
}

class LocationSelectionView: UIView {

    let addLocationLabel = CFTitleLabel()
    let addLocationButton = CFHeaderButton()
    let stackView = UIStackView()
    
    var isEditingLocation = false
    let storeSelection = StoreSelectionView()
    let aisleSelection = AisleSelectionView()
    let deleteLocationButton = CFButton()
    let cancelEditButton = CFButton()
    let addToLocationsButton = CFButton()
    
    weak var delegate: LocationSelectionViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        layoutUI()
        
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(storeSelection)
        stackView.addArrangedSubview(aisleSelection)
    }
    
    
    
    func layoutUI() {
        addSubview(addLocationButton)
        addSubview(stackView)
        addSubview(deleteLocationButton)
        addSubview(cancelEditButton)
        addSubview(addToLocationsButton)
        
        let headerTitle = isEditingLocation ? "Edit Location:" : "Add Location:"
        let addUpdateButtonTitle = isEditingLocation ? "Update" : "Add to locations"
        
        addLocationButton.set(title: headerTitle)
        addLocationButton.addTarget(self, action: #selector(expandButtonPressed), for: .touchUpInside)
        
        deleteLocationButton.isHidden = isEditingLocation ? false : true
        deleteLocationButton.set(backgroundColor: Colors.red, title: "Remove")
        
        cancelEditButton.isHidden = isEditingLocation ? false : true
        cancelEditButton.set(backgroundColor: .systemGray3, title: "Cancel")
        cancelEditButton.addTarget(self, action: #selector(cancelEdit), for: .touchUpInside)
        addToLocationsButton.set(backgroundColor: .black, title: addUpdateButtonTitle)
        addToLocationsButton.addTarget(self, action: #selector(addToLocations), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addLocationButton.topAnchor.constraint(equalTo: self.topAnchor),
            addLocationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addLocationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addLocationButton.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: addLocationButton.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            
            deleteLocationButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            deleteLocationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            deleteLocationButton.trailingAnchor.constraint(equalTo: cancelEditButton.leadingAnchor, constant: -5),
            deleteLocationButton.heightAnchor.constraint(equalToConstant: 30),
            
            cancelEditButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            cancelEditButton.leadingAnchor.constraint(equalTo: deleteLocationButton.trailingAnchor, constant: 5),
            cancelEditButton.trailingAnchor.constraint(equalTo: addToLocationsButton.leadingAnchor, constant: -5),
            cancelEditButton.heightAnchor.constraint(equalToConstant: 30),
            
            
            
            addToLocationsButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            addToLocationsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            //addToLocationsButton.widthAnchor.constraint(equalToConstant: 150),
            addToLocationsButton.heightAnchor.constraint(equalToConstant: 30)
        
        
        
        ])
    }
    
    @objc func expandButtonPressed() {
        delegate.didToggleLocationSelection()
    }
    
    @objc func cancelEdit() {
        isEditingLocation = false
        layoutUI()
        delegate.didToggleLocationSelection()
    }
    
    @objc func addToLocations() {
       
        delegate.addToLocationsButtonPressed()
       
    }
    
    private func configureAddLocationButton() {
        
    }
    
   
}


    
    

