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
        addSubview(addToLocationsButton)
        
        let headerTitle = isEditingLocation ? "Edit Location:" : "Add Location:"
        let addUpdateButtonTitle = isEditingLocation ? "Update" : "Add to locations"
        
        addLocationButton.set(title: headerTitle)
        addLocationButton.addTarget(self, action: #selector(expandButtonPressed), for: .touchUpInside)
        
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
            
            addToLocationsButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            addToLocationsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            addToLocationsButton.widthAnchor.constraint(equalToConstant: 150),
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
    
}


    
    

