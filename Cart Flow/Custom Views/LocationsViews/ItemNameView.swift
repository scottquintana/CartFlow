//
//  ItemNameView.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/28/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class ItemNameView: UIView {

    let itemNameButton = CFHeaderButton()
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
        addSubview(itemNameButton)
        addSubview(itemNameTextField)
        
        
        itemNameButton.set(title: "Item name: (required)")
        itemNameTextField.text = selectedItem?.name ?? ""
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            itemNameButton.topAnchor.constraint(equalTo: self.topAnchor),
            itemNameButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemNameButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemNameButton.heightAnchor.constraint(equalToConstant: 40),
            
            itemNameTextField.topAnchor.constraint(equalTo: itemNameButton.bottomAnchor, constant: padding),
            itemNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            itemNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            itemNameTextField.heightAnchor.constraint(equalToConstant: 36)
            
        ])
    }
    
}
