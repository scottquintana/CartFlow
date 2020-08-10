//
//  ItemListCell.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/5/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class ItemListCell: UITableViewCell {

    static let reuseID = "ItemListCell"
    
    let itemLabel = CFTitleLabel(textAlignment: .left, fontSize: 20)
    
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
        addSubview(itemLabel)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            itemLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            itemLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            itemLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
