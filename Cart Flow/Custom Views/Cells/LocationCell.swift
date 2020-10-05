//
//  LocationCell.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/20/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class LocationCell: UICollectionViewCell {

    static let reuseID = "LocationCell"
    
    let storeLabel = CFLocationLabel()
    let aisleLabel = CFLocationLabel()
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
        locationBox.addSubview(aisleLabel)
        locationBox.backgroundColor = .black
        
        locationBox.layer.cornerRadius = 10
        locationBox.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            
            locationBox.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            locationBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationBox.trailingAnchor.constraint(equalTo: trailingAnchor),
            locationBox.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: padding),
            
            storeLabel.topAnchor.constraint(equalTo: locationBox.topAnchor, constant: 5),
            storeLabel.leadingAnchor.constraint(equalTo: locationBox.leadingAnchor, constant: padding),
            storeLabel.trailingAnchor.constraint(equalTo: locationBox.trailingAnchor, constant: -padding),
            storeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            aisleLabel.topAnchor.constraint(equalTo: storeLabel.bottomAnchor, constant: 5),
            aisleLabel.leadingAnchor.constraint(equalTo: locationBox.leadingAnchor, constant: padding),
            aisleLabel.trailingAnchor.constraint(equalTo: locationBox.trailingAnchor, constant: -padding),
            aisleLabel.bottomAnchor.constraint(equalTo: locationBox.bottomAnchor, constant: -padding)
        
        ])
    }
    
    func set(location: Aisle) {
        storeLabel.text = location.parentStore!.name
        aisleLabel.text = location.label
    }
    

}
