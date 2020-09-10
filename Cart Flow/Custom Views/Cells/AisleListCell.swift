//
//  AisleListCell.swift
//  Cart Flow
//
//  Created by Scott Quintana on 9/9/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class AisleListCell: UITableViewCell {
    
    static let reuseID = "AisleListCell"
    
    let aisleLabel = CFBodyLabel()
    let descriptionLabel = CFBodyLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(aisle: Aisle) {
        self.aisleLabel.text = aisle.label
        if let description = aisle.desc {
            self.descriptionLabel.text = "- \(description)"
        } else {
            descriptionLabel.text = ""
        }
    }
    
    private func configure() {
        addSubview(aisleLabel)
        addSubview(descriptionLabel)
        
        backgroundColor = .white
        aisleLabel.textColor = .black
        descriptionLabel.textColor = .black
        
        NSLayoutConstraint.activate([
            aisleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            aisleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            aisleLabel.widthAnchor.constraint(equalToConstant: 25),
            
            descriptionLabel.centerYAnchor.constraint(equalTo: aisleLabel.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: aisleLabel.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
