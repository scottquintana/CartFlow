//
//  ItemNameView.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/28/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class ItemNameView: UIView {

    let itemNameLabel = CFSecondaryTitleLabel()
    let itemNameTextField = CFTextField()
    var selectedItem: ShoppingItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(itemNameLabel)
        addSubview(itemNameTextField)
        
        
        itemNameLabel.text = "Name: (required)"
        itemNameTextField.text = selectedItem?.name ?? ""
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            itemNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            itemNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            itemNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            itemNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            itemNameTextField.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: padding),
            itemNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            itemNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            itemNameTextField.heightAnchor.constraint(equalToConstant: 36)
            
        ])
    }
    
}
