//
//  ItemLocationsView.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/25/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class ItemLocationsView: UIView {
    
    let locationsLabel = CFTitleLabel()
    let locationsList = UITableView()
    var itemLocations: [Aisle] = []
    var tableViewHeight: NSLayoutConstraint!
    var sectionHeight: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        addSubview(locationsLabel)
        addSubview(locationsList)
        
        locationsLabel.text = "Locations"
        
        locationsList.delegate = self
        locationsList.dataSource = self
        locationsList.translatesAutoresizingMaskIntoConstraints = false
        locationsList.rowHeight = 25
        locationsList.isScrollEnabled = false
        locationsList.separatorStyle = .none
        
        locationsList.register(LocationCell.self, forCellReuseIdentifier: LocationCell.reuseID)
        
        let padding: CGFloat = 10
        locationsList.layoutIfNeeded()
        sectionHeight = (locationsList.rowHeight * CGFloat(itemLocations.count))
        tableViewHeight = locationsList.heightAnchor.constraint(equalToConstant: sectionHeight)
        tableViewHeight.isActive = true
        
        
        NSLayoutConstraint.activate([
            locationsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            locationsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            locationsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            locationsLabel.heightAnchor.constraint(equalToConstant: 22),
            
            
            locationsList.topAnchor.constraint(equalTo: locationsLabel.bottomAnchor, constant: padding),
            locationsList.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            locationsList.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            
        ])
    }
    
    func set(itemLocations: [Aisle]) {
        self.itemLocations = itemLocations
        
        self.locationsList.reloadData()
        tableViewHeight.constant = (locationsList.rowHeight * CGFloat(itemLocations.count))
     
        
        print("Set was called")
    }
    
}

extension ItemLocationsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseID, for: indexPath) as! LocationCell
        let currentAisle = itemLocations[indexPath.row]
        
        cell.set(location: currentAisle)
        cell.backgroundColor = .systemPink
        return cell
    }
    
    
}
