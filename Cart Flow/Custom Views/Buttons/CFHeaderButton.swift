//
//  CFHeaderButton.swift
//  Cart Flow
//
//  Created by Scott Quintana on 9/10/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class CFHeaderButton: UIButton {
    
    let headerLabel = CFHeaderLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        addSubview(headerLabel)
        layer.cornerRadius = 16
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    
    func set(title: String) {
        headerLabel.text = title
    }
    
}
