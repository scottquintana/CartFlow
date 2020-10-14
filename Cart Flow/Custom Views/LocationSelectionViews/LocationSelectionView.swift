//
//  LocationSelectionVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/25/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

protocol LocationSelectionViewDelegate: class {
    func didToggleLocationSelection()
    
    func didSelectStore(selectedStore: GroceryStore)
    
    func didPressAddStore()
}

class LocationSelectionView: UIView {

    let addLocationLabel = CFTitleLabel()
    let addLocationButton = CFHeaderButton()

    let storesLabel = CFSecondaryTitleLabel()
    let addButton = CFPlusButton()

    var storesCollectionView: UICollectionView!

    var stores: [GroceryStore] = []

    
    weak var delegate: LocationSelectionViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStoresCollection()
        layoutUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStores(stores: [GroceryStore]) {
        self.stores = stores
        storesCollectionView.reloadData()
    }

    private func configureStoresCollection() {
        storesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureFlowLayout())
        storesCollectionView.backgroundColor = .white
        
        storesCollectionView.delegate = self
        storesCollectionView.dataSource = self
        storesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        storesCollectionView.allowsMultipleSelection = false
        storesCollectionView.register(StoreCell.self, forCellWithReuseIdentifier: StoreCell.reuseID)
    }
    
    func layoutUI() {
        addSubview(addLocationButton)
        addSubview(storesCollectionView)
        addSubview(storesLabel)
        addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(addNewStore), for: .touchUpInside)
        
        let headerTitle = "Add Location"
        storesLabel.text = "Stores:"
        addLocationButton.set(title: headerTitle)
        addLocationButton.addTarget(self, action: #selector(expandButtonPressed), for: .touchUpInside)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            addLocationButton.topAnchor.constraint(equalTo: self.topAnchor),
            addLocationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addLocationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addLocationButton.heightAnchor.constraint(equalToConstant: 40),
            
            storesLabel.topAnchor.constraint(equalTo: addLocationButton.bottomAnchor, constant: padding),
            storesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            storesLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor),
            storesLabel.heightAnchor.constraint(equalToConstant: 26),
            
            addButton.centerYAnchor.constraint(equalTo: storesLabel.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            addButton.widthAnchor.constraint(equalToConstant: 26),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            
            storesCollectionView.topAnchor.constraint(equalTo: storesLabel.bottomAnchor, constant: padding),
            storesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            storesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            storesCollectionView.heightAnchor.constraint(equalToConstant: 60)
        
        ])
    }
    
    
    func configureFlowLayout() -> UICollectionViewFlowLayout {
        let padding: CGFloat = 5
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.sectionInset = UIEdgeInsets(top: -24, left: padding, bottom: 0, right: padding)
        flowLayout.itemSize = CGSize(width: 100, height: 40)
        flowLayout.minimumLineSpacing = 5
        
        return flowLayout
    }
    
    
    @objc func expandButtonPressed() {
        delegate.didToggleLocationSelection()
    }
    
    
    @objc func addNewStore() {
        delegate.didPressAddStore()
    }
    

    
}

//MARK: - CollectionView

extension LocationSelectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCell.reuseID, for: indexPath) as! StoreCell
        cell.set(location: stores[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let store = stores[indexPath.row]
        delegate.didSelectStore(selectedStore: store)
    }
    
}
    
    

