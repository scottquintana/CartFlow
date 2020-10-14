//
//  SelectAisleVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 10/14/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit
import CoreData

protocol SelectAisleVCDelegate: class {
    func didPressEditLocation()
    
    func didSelectLocation(location: Aisle)
}

class SelectAisleVC: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let aisleTableView = UITableView()
    var selectedStore: GroceryStore!
    var aisles: [Aisle] = []
    
    let containerView = UIView()
    
    weak var delegate: SelectAisleVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainer()
        configureTableView()
        layoutUI()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)

    }
    
    
    private func configureContainer() {
        view.addSubview(containerView)
        containerView.backgroundColor = .black
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let topBottomPadding: CGFloat = 100
        let sidePadding: CGFloat = 40
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: topBottomPadding),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sidePadding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sidePadding),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -topBottomPadding)
        ])
    }
    
    
    private func configureTableView() {
        aisleTableView.delegate = self
        aisleTableView.dataSource = self
        aisleTableView.register(AisleListCell.self, forCellReuseIdentifier: AisleListCell.reuseID)
    }
    
    
    func setStoreForAisles(store: GroceryStore) {
        self.selectedStore = store
        loadAisles()
    }
    
    
    private func layoutUI() {
        let stackView = UIStackView()
        
        let aislesLabel = CFSecondaryTitleLabel(textAlignment: .center)
        let editButton = CFButton(backgroundColor: Colors.green, title: "Edit Location")
        let cancelButton = CFButton(backgroundColor: .systemGray3, title: "Cancel")
        
        containerView.addSubview(aislesLabel)
        containerView.addSubview(aisleTableView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(editButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        aislesLabel.text = "Aisles"
        aislesLabel.textColor = .white
        

        aisleTableView.layer.cornerRadius = 16
        aisleTableView.backgroundColor = .white
        aisleTableView.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editLocation), for: .touchUpInside)
        
        let stackPadding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            aislesLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2),
            aislesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 2),
            aislesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -2),
            aislesLabel.heightAnchor.constraint(equalToConstant: 26),
            
            aisleTableView.topAnchor.constraint(equalTo: aislesLabel.bottomAnchor, constant: 2),
            aisleTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            aisleTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            aisleTableView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10),
            
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: stackPadding),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -stackPadding),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -stackPadding),
            stackView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    
    func loadAisles() {
        if let storeName = selectedStore.name {
            let request: NSFetchRequest<Aisle> = Aisle.fetchRequest()
            let predicate = NSPredicate(format: "ANY parentStore.name =[cd] %@", storeName)
            let sortDescriptor = NSSortDescriptor(key: "label", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
            request.predicate = predicate
            request.sortDescriptors = [sortDescriptor]
            
            do {
                aisles = try context.fetch(request)
            } catch {
                print("Error loading aisles")
            }
        }
        aisleTableView.reloadData()
    }
    
    @objc func editLocation() {
        delegate.didPressEditLocation()
    }
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}

//MARK: - TableView

extension SelectAisleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        aisles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AisleListCell.reuseID) as! AisleListCell
        let aisle = aisles[indexPath.row]
        cell.set(aisle: aisle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAisle = aisles[indexPath.row]
        
        delegate.didSelectLocation(location: selectedAisle)
    }
    
    
}
