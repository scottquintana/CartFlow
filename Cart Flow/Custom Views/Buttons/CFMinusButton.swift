//
//  CFMinusButton.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/25/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class CFMinusButton: UIButton {

    let minusImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(minusImageView)
        
        minusImageView.translatesAutoresizingMaskIntoConstraints = false
        minusImageView.contentMode = .scaleAspectFill
        minusImageView.tintColor = .systemRed
        minusImageView.image = SFSymbols.minus
       
        
        NSLayoutConstraint.activate([
            minusImageView.topAnchor.constraint(equalTo: self.topAnchor),
            minusImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            minusImageView.widthAnchor.constraint(equalToConstant: 20),
            minusImageView.heightAnchor.constraint(equalToConstant: 20)
        
        ])
    }
    
}
