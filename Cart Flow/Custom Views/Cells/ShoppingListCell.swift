//
//  ShoppingListCell.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/11/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell {
    static let reuseID = "ShoppingListCell"
    
    let itemLabel = CFTitleLabel(textAlignment: .left, fontSize: 20)
    let backgroundBox = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(item: ShoppingItem) {
        itemLabel.text = item.name
        
    }
    
    
    private func configure() {
        addSubview(backgroundBox)
        backgroundBox.addSubview(itemLabel)
        
        let padding: CGFloat = 20
        backgroundColor = .none
        backgroundBox.backgroundColor = Colors.darkBar
        backgroundBox.layer.cornerRadius = 10
        backgroundBox.layer.borderColor = UIColor.black.cgColor
        //backgroundBox.layer.borderWidth = 1
        backgroundBox.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            
            backgroundBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backgroundBox.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            backgroundBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            backgroundBox.heightAnchor.constraint(equalToConstant: 50),
            
           
            itemLabel.centerYAnchor.constraint(equalTo: backgroundBox.centerYAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: backgroundBox.leadingAnchor, constant: padding),
            itemLabel.trailingAnchor.constraint(equalTo: backgroundBox.trailingAnchor, constant: -padding),
            itemLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    }
}
