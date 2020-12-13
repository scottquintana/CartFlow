//
//  CFEmptyStateView.swift
//  Cart Flow
//
//  Created by Scott Quintana on 12/2/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class CFEmptyStateView: UIView {

    let messageLabel = CFTitleLabel(textAlignment: .center, fontSize: 26)
    let cartImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String, image: String) {
        self.init()
        messageLabel.text = message
        cartImage.image = UIImage(named: image)
    }
    
    private func configure() {
        addSubview(cartImage)
        addSubview(messageLabel)
        
        
        messageLabel.numberOfLines = 4
        
        
        cartImage.alpha = 0.4
        cartImage.tintColor = .secondarySystemBackground
        cartImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -130),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
        
            cartImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cartImage.widthAnchor.constraint(equalToConstant: 250),
            cartImage.heightAnchor.constraint(equalToConstant: 250),
            cartImage.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10)
        
        ])
    }
}
