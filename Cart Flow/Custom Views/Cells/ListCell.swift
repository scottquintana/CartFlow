//
//  ListCell.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/3/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    static let reuseID = "ListCell"
    
    let listNameLabel = CFTitleLabel(textAlignment: .left, fontSize: 26)
    let listDateUpdated = CFSecondaryTitleLabel(textAlignment: .right)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(shoppingList: ShoppingList) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: shoppingList.lastUpdate!)
        listNameLabel.text = shoppingList.name ?? "Untitled List"
        listDateUpdated.text = dateString
        
        
    }
    
    private func configure() {
        addSubview(listNameLabel)
        addSubview(listDateUpdated)
    
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            listNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            listNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            listNameLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -padding),
            listNameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            listDateUpdated.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            listDateUpdated.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: padding),
            listDateUpdated.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            listDateUpdated.heightAnchor.constraint(equalToConstant: 40)
        
        ])
    }
}
