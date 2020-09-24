//
//  CFEditButton.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/21/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class CFEditButton: UIButton {

    let editImageView = UIImageView()
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         configure()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     private func configure() {
         translatesAutoresizingMaskIntoConstraints = false
         
         addSubview(editImageView)
         
         editImageView.translatesAutoresizingMaskIntoConstraints = false
         editImageView.contentMode = .scaleAspectFill
         editImageView.tintColor = .secondaryLabel
         editImageView.image = SFSymbols.edit
        
         
         NSLayoutConstraint.activate([
             editImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
             editImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             editImageView.widthAnchor.constraint(equalToConstant: 26),
             editImageView.heightAnchor.constraint(equalToConstant: 26)
         
         ])
     }
}
