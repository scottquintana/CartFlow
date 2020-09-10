//
//  LocationCell.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/20/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    static let reuseID = "LocationCell"
    
    let storeLabel = CFLocationLabel()
    let aisleLabel = CFLocationLabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(storeLabel)
        addSubview(aisleLabel)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            storeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            storeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            storeLabel.trailingAnchor.constraint(equalTo: aisleLabel.leadingAnchor, constant: -padding),
            storeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            aisleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            aisleLabel.leadingAnchor.constraint(equalTo: storeLabel.trailingAnchor, constant: padding),
            aisleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            aisleLabel.heightAnchor.constraint(equalToConstant: 20)
        
        ])
    }
    
    func set(location: Aisle) {
        storeLabel.text = location.parentStore!.name
        aisleLabel.text = location.label
    }
    

}
