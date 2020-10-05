//
//  ItemLocationsView.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/25/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

protocol ItemLocationsViewDelegate: class {
    func didPressEditLocation()
    
    func didPressRemoveLocation(aisleToRemove: Aisle)
}

class ItemLocationsView: UIView {
    
    let locationsButton = CFHeaderButton()
    var locationsList: UICollectionView!
    let cancelButton = CFButton()
    let removeButton = CFButton()
    var itemLocations: [Aisle] = []
    var selectedLocation: Aisle?

    weak var delegate: ItemLocationsViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        locationsList = UICollectionView(frame: .zero, collectionViewLayout: configureFlowLayout())
        locationsList.backgroundColor = .white
        
        addSubview(locationsButton)
        addSubview(locationsList)
        addSubview(removeButton)
        addSubview(cancelButton)
        
        locationsButton.set(title: "Locations:")
        
        locationsList.translatesAutoresizingMaskIntoConstraints = false
        locationsList.allowsMultipleSelection = false
        locationsList.delegate = self
        locationsList.dataSource = self
        locationsList.register(LocationCell.self, forCellWithReuseIdentifier: LocationCell.reuseID)
        
        removeButton.set(backgroundColor: Colors.red, title: "Remove")
        removeButton.addTarget(self, action: #selector(removeLocation), for: .touchUpInside)
        
        cancelButton.set(backgroundColor: .systemGray4, title: "Cancel")
        cancelButton.addTarget(self, action: #selector(cancelSelectedLocation), for: .touchUpInside)
        
        let padding: CGFloat = 10
        
        
        NSLayoutConstraint.activate([
            locationsButton.topAnchor.constraint(equalTo: self.topAnchor),
            locationsButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            locationsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            locationsButton.heightAnchor.constraint(equalToConstant: 40),
            
            
            locationsList.topAnchor.constraint(equalTo: locationsButton.bottomAnchor),
            locationsList.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            locationsList.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            locationsList.heightAnchor.constraint(equalToConstant: 95),
            
            removeButton.topAnchor.constraint(equalTo: locationsList.bottomAnchor, constant: 8),
            removeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            removeButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -padding),
            removeButton.heightAnchor.constraint(equalToConstant: 36),
            
            cancelButton.topAnchor.constraint(equalTo: locationsList.bottomAnchor, constant: 8),
            cancelButton.leadingAnchor.constraint(equalTo: removeButton.trailingAnchor, constant: padding),
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            cancelButton.heightAnchor.constraint(equalToConstant: 36)
            
        ])
    }
    
    func configureFlowLayout() -> UICollectionViewFlowLayout {
        let padding: CGFloat = 5
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.sectionInset = UIEdgeInsets(top: -14, left: padding, bottom: 0, right: padding)
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        flowLayout.minimumLineSpacing = 5
        
        return flowLayout
    }
    
    
    func set(itemLocations: [Aisle]) {
        self.itemLocations = itemLocations
        
        self.locationsList.reloadData()
    }
    
    
    @objc func removeLocation() {
        delegate.didPressRemoveLocation(aisleToRemove: selectedLocation!)
    }
    
    
    @objc func cancelSelectedLocation() {
        delegate?.didPressEditLocation()
    }
}

//MARK: - CollectionView Extensions

extension ItemLocationsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemLocations.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = locationsList.dequeueReusableCell(withReuseIdentifier: LocationCell.reuseID, for: indexPath) as! LocationCell
        let currentAisle = itemLocations[indexPath.row]
        
        cell.set(location: currentAisle)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        
        selectedLocation = itemLocations[indexPath.item]
        delegate?.didPressEditLocation()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! LocationCell
        selectedCell.locationBox.backgroundColor = Colors.red
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! LocationCell
        selectedCell.locationBox.backgroundColor = .black
    }
}
