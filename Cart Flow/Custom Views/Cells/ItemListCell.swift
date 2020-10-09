//
//  ItemListCell.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/5/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

protocol ItemListCellDelegate: class {
    func didTapEditItemButton(for item: ShoppingItem)
}

class ItemListCell: UITableViewCell {

    static let reuseID = "ItemListCell"
    
    let itemLabel = CFTitleLabel(textAlignment: .left, fontSize: 20)
    let lastPurchasedLabel = UILabel()
    let editItemButton = CFEditButton()
    var shoppingItem: ShoppingItem? = nil
    weak var delegate: ItemListCellDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(item: ShoppingItem) {
        itemLabel.text = item.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let lastPurchasedDate = item.lastPurchased {
            let dateString = dateFormatter.string(from: lastPurchasedDate)
            lastPurchasedLabel.text = "Last purchased on: \(dateString)"
        } else {
            lastPurchasedLabel.text = "Item has no record of purchase"
        }
    
        self.shoppingItem = item
    }
    
    
    private func configure() {
        contentView.addSubview(itemLabel)
        contentView.addSubview(lastPurchasedLabel)
        contentView.addSubview(editItemButton)
        lastPurchasedLabel.textColor = .systemGray
        lastPurchasedLabel.font = lastPurchasedLabel.font.withSize(12)
        lastPurchasedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        editItemButton.addTarget(self, action: #selector(self.editButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            itemLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -6),
            itemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            itemLabel.trailingAnchor.constraint(equalTo: editItemButton.leadingAnchor, constant: -padding),
            itemLabel.heightAnchor.constraint(equalToConstant: 24),
            
            lastPurchasedLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 3),
            lastPurchasedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            lastPurchasedLabel.trailingAnchor.constraint(equalTo: editItemButton.leadingAnchor, constant: -padding),
            lastPurchasedLabel.heightAnchor.constraint(equalToConstant: 12),
            
            
            editItemButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            editItemButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            editItemButton.heightAnchor.constraint(equalToConstant: 40),
            editItemButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    @objc func editButtonPressed() {
        delegate?.didTapEditItemButton(for: self.shoppingItem!)
    }
}
