//
//  CFPlusButton.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/13/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class CFPlusButton: UIButton {

    let plusImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(plusImageView)
        
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        plusImageView.contentMode = .scaleAspectFill
        plusImageView.tintColor = .black
        plusImageView.image = SFSymbols.plus
       
        
        NSLayoutConstraint.activate([
            plusImageView.topAnchor.constraint(equalTo: self.topAnchor),
            plusImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            plusImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            plusImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        ])
    }
}
