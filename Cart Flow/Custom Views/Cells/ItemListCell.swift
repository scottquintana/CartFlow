//
//  ItemListCell.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/5/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

protocol ItemListCellDelegate {
    func didTapEditItemButton(for item: ShoppingItem)
}

class ItemListCell: UITableViewCell {

    static let reuseID = "ItemListCell"
    
    let itemLabel = CFTitleLabel(textAlignment: .left, fontSize: 20)
    let editItemButton = CFEditButton()
    var shoppingItem: ShoppingItem? = nil
    var delegate: ItemListCellDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(item: ShoppingItem) {
        itemLabel.text = item.name
        self.shoppingItem = item
    }
    
    
    private func configure() {
        contentView.addSubview(itemLabel)
        contentView.addSubview(editItemButton)
        let padding: CGFloat = 20
        editItemButton.addTarget(self, action: #selector(self.editButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            itemLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            itemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            itemLabel.trailingAnchor.constraint(equalTo: editItemButton.leadingAnchor, constant: -padding),
            itemLabel.heightAnchor.constraint(equalToConstant: 24),
            
            editItemButton.centerYAnchor.constraint(equalTo: itemLabel.centerYAnchor),
            editItemButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            editItemButton.heightAnchor.constraint(equalToConstant: 40),
            editItemButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        
    }
    
    
    @objc func editButtonPressed() {
        delegate?.didTapEditItemButton(for: self.shoppingItem!)
        print("hi")
    }
}
