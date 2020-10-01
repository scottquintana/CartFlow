//
//  CFTitleButton.swift
//  Cart Flow
//
//  Created by Scott Quintana on 9/30/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class CFTitleButton: UIButton {

    let title = UILabel()
    let downArrow = UIImageView(image: SFSymbols.downArrow)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(title)
        addSubview(downArrow)
        
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        
        downArrow.translatesAutoresizingMaskIntoConstraints = false
        downArrow.tintColor = .black
        
        NSLayoutConstraint.activate([
            
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -8),
            title.heightAnchor.constraint(equalToConstant: 26),
            
            downArrow.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 2),
            downArrow.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 4),
            downArrow.widthAnchor.constraint(equalToConstant: 16),
            downArrow.heightAnchor.constraint(equalToConstant: 16)
        ])
        
    }
    
    func set(storeName: String) {
        self.title.text = storeName
    }
    
    
}
