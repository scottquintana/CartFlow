//
//  CFAlertContainerView.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/31/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class CFAlertContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor = .systemGray
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
