//
//  StoreCell.swift
//  Cart Flow
//
//  Created by Scott Quintana on 10/14/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class StoreCell: UICollectionViewCell {
    
    static let reuseID = "StoreCell"
    
    let storeLabel = CFLocationLabel()
    let locationBox = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    private func configure() {
        addSubview(locationBox)
        locationBox.addSubview(storeLabel)
        locationBox.backgroundColor = .black
        
        locationBox.layer.cornerRadius = 16
        locationBox.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            
            locationBox.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            locationBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationBox.trailingAnchor.constraint(equalTo: trailingAnchor),
            locationBox.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: padding),
            
            storeLabel.centerYAnchor.constraint(equalTo: locationBox.centerYAnchor),
            storeLabel.leadingAnchor.constraint(equalTo: locationBox.leadingAnchor, constant: padding),
            storeLabel.trailingAnchor.constraint(equalTo: locationBox.trailingAnchor, constant: -padding),
            storeLabel.heightAnchor.constraint(equalToConstant: 25),
        
        ])
    }
    
    
    func set(location: GroceryStore) {
        storeLabel.text = location.name
    }
}

