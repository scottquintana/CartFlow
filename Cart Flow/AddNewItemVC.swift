//
//  AddNewItemVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/6/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

protocol AddNewItemVCDelegate: class {
    
    func didAddNewItem(controller: AddNewItemVC, item: ShoppingItem)
}

class AddNewItemVC: UIViewController {
    
    let itemNameLabel = CFBodyLabel(textAlignment: .left)
    let itemNameTextField = CFTextField()
    let itemDescriptionLabel = CFBodyLabel(textAlignment: .left)
    let itemDescriptionTextField = CFTextField()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let addButton = CFButton(backgroundColor: .systemBlue, title: "Add New Item")
    
    var delegate: AddNewItemVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(itemNameLabel)
        view.addSubview(itemNameTextField)
        view.addSubview(addButton)
        
        configureItemName()
        configureCancelButton()
        configureAddButton()
        
        view.backgroundColor = .systemBackground
    }
    
    
    
    private func configureItemName() {
        
        itemNameLabel.text = "Name: (required)"
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            itemNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            itemNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            itemNameTextField.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: padding),
            itemNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemNameTextField.heightAnchor.constraint(equalToConstant: 36)
            
        ])
        
    }
    private func configureCancelButton() {
        
        let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        self.view.addSubview(navigationBar)
        let cancelButton =  UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = cancelButton
        navigationBar.setItems([navigationItem], animated: false)
    }
    
    func configureAddButton() {
        addButton.addTarget(self, action: #selector(pushItemListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: 50),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
        itemNameTextField.text = ""
    }
    
    @objc func pushItemListVC() {
        
        
        let newItem = ShoppingItem(context: context)
        newItem.name = itemNameTextField.text!
        print(context)
        print(newItem)
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        itemNameTextField.text = ""
        
        dismiss(animated: true)
        
        
    }
    
}
