//
//  LocationSelectionVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/25/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class LocationSelectionView: UIView {

    let addLocationLabel = CFTitleLabel()
    let stackView = UIStackView()
    
    let storeSelection = StoreSelectionView()
    let aisleSelection = AisleSelectionView()
    let addLocationButton = CFButton()
    
    
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
    
    private func layoutUI() {
        addSubview(addLocationLabel)
        addSubview(stackView)
        
        addLocationLabel.text = "Add item location"
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            addLocationLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            addLocationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            addLocationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            addLocationLabel.heightAnchor.constraint(equalToConstant: 30),
            
            stackView.topAnchor.constraint(equalTo: addLocationLabel.bottomAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        
        
        
        ])
    }
    
    
    private func configureAddLocationButton() {
        
    }
    
   
}


    
    

