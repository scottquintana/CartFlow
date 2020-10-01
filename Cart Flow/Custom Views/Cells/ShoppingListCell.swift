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
    let itemStatusImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(item: ShoppingItem) {
        itemLabel.text = item.name
        
        
        if item.inCart {
            itemStatusImage.image = SFSymbols.check
            itemStatusImage.tintColor = Colors.checkGreen
        } else if item.outOfStock {
            itemStatusImage.image = SFSymbols.flag
            itemStatusImage.tintColor = Colors.yellow
        } else {
            itemStatusImage.image = SFSymbols.circle
            itemStatusImage.tintColor = .black
        }
    }
    
    
    private func configure() {
        addSubview(backgroundBox)
        backgroundBox.addSubview(itemLabel)
        backgroundBox.addSubview(itemStatusImage)
        
        let padding: CGFloat = 14
        backgroundColor = Colors.green
        backgroundBox.backgroundColor = .white
        backgroundBox.layer.cornerRadius = 16
        backgroundBox.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.textColor = .black
        itemStatusImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            backgroundBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backgroundBox.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            backgroundBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            backgroundBox.heightAnchor.constraint(equalToConstant: 50),
            
            itemStatusImage.centerYAnchor.constraint(equalTo: backgroundBox.centerYAnchor),
            itemStatusImage.leadingAnchor.constraint(equalTo: backgroundBox.leadingAnchor, constant: padding),
            itemStatusImage.widthAnchor.constraint(equalToConstant: 25),
            itemStatusImage.heightAnchor.constraint(equalToConstant: 25),
            
            itemLabel.centerYAnchor.constraint(equalTo: backgroundBox.centerYAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: itemStatusImage.trailingAnchor, constant: padding),
            itemLabel.trailingAnchor.constraint(equalTo: backgroundBox.trailingAnchor, constant: -padding),
            itemLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    }
}
