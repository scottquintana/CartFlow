//
//  EditAislesView.swift
//  Cart Flow
//
//  Created by Scott Quintana on 9/8/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

protocol EditAisleViewDelegate: class {
    func didAddAisle(aisle: Aisle)
    
    func didUpdateAisle()
}

class EditAislesView: UIView {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let stackView = UIStackView()
    let aisleStackView = UIStackView()
    let descriptionStackView = UIStackView()
    let stackPadding: CGFloat = 5
    
    let aisleHeaderLabel = CFSecondaryTitleLabel()
    let aisleLabel = CFBodyLabel()
    let aisleTextField = CFTextField()
    let descriptionLabel = CFBodyLabel()
    let descriptionTextField = CFTextField()
    
    let cancelEditButton = CFButton(backgroundColor: .systemGray5, title: "Cancel")
    let addUpdateButton = CFButton(backgroundColor: Colors.darkBar, title: "Add aisle")
    
    var isEditingAisle = false
    var selectedStore: GroceryStore?
    var selectedAisle: Aisle?
    
    weak var delegate: EditAisleViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        configureMainStackView()
        configureAisleStackView()
        configureDescriptionStackView()
        configureButtons()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMainStackView() {
        addSubview(stackView)
        
        
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(aisleStackView)
        stackView.addArrangedSubview(descriptionStackView)
    }
    
    
    private func configureAisleStackView() {
        addSubview(aisleStackView)
        
        
        aisleStackView.axis = .vertical
        aisleStackView.distribution = .equalCentering
        
        aisleStackView.translatesAutoresizingMaskIntoConstraints = false
     
        aisleLabel.text = "Aisle:"
        aisleLabel.textColor = .white
        aisleTextField.text = selectedAisle?.label ?? ""
        
        NSLayoutConstraint.activate([
            aisleStackView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5),
            aisleStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 5),
            aisleTextField.heightAnchor.constraint(equalToConstant: 36)
            
        
        ])
        aisleStackView.addArrangedSubview(aisleLabel)
        aisleStackView.addArrangedSubview(aisleTextField)
    }
    
    
    private func configureDescriptionStackView() {
        addSubview(descriptionStackView)
       
        
        descriptionStackView.axis = .vertical
        descriptionStackView.distribution = .equalCentering
     
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.addSubview(descriptionLabel)
        descriptionStackView.addSubview(descriptionTextField)
        descriptionLabel.text = "Description:"
        descriptionLabel.textColor = .white
        descriptionTextField.text = selectedAisle?.description ?? ""
        
        NSLayoutConstraint.activate([
            descriptionStackView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5),
            descriptionStackView.leadingAnchor.constraint(equalTo: aisleStackView.trailingAnchor, constant: 5),
            descriptionStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -5),
           
            descriptionTextField.heightAnchor.constraint(equalToConstant: 36),
            descriptionTextField.widthAnchor.constraint(equalToConstant: 200)
        
        ])
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(descriptionTextField)
        
    }
    
    private func configureButtons() {
        
        
        addSubview(addUpdateButton)
        addSubview(cancelEditButton)
        
        addUpdateButton.addTarget(self, action: #selector(addUpdateAisleInfo), for: .touchUpInside)
        cancelEditButton.addTarget(self, action: #selector(cancelAisleUpdate), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addUpdateButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            addUpdateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            addUpdateButton.widthAnchor.constraint(equalToConstant: 100),
            addUpdateButton.heightAnchor.constraint(equalToConstant: 30),
            
            cancelEditButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            cancelEditButton.trailingAnchor.constraint(equalTo: addUpdateButton.leadingAnchor, constant: -5),
            cancelEditButton.widthAnchor.constraint(equalToConstant: 100),
            cancelEditButton.heightAnchor.constraint(equalToConstant: 30)
        
        ])
    }
    
    private func layoutUI() {
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 85)
        
        ])
    }
    
    func loadAisleToEdit(selectedAisle: Aisle) {
        isEditingAisle = true
        self.selectedAisle = selectedAisle
        aisleTextField.text = selectedAisle.label
        descriptionTextField.text = selectedAisle.desc
        addUpdateButton.set(backgroundColor: Colors.darkBar, title: "Update")
    }
    
    
    @objc func cancelAisleUpdate() {
        
        aisleTextField.text = ""
        descriptionTextField.text = ""
        isEditingAisle = false
        addUpdateButton.set(backgroundColor: Colors.darkBar, title: "Add aisle")
        
        self.endEditing(true)
        
    }
    
    
    @objc func addUpdateAisleInfo() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        if isEditingAisle {
            self.selectedAisle?.label = aisleTextField.text
            self.selectedAisle?.desc = descriptionTextField.text
            delegate.didUpdateAisle()
        } else {
            let newAisle = Aisle(context: context)
            newAisle.label = aisleTextField.text
            newAisle.desc = descriptionTextField.text
            
            delegate.didAddAisle(aisle: newAisle)
        }
        
        selectedAisle = nil
        aisleTextField.text = ""
        descriptionTextField.text = ""
        isEditingAisle = false
        addUpdateButton.set(backgroundColor: Colors.darkBar, title: "Add aisle")
        
        self.endEditing(true)
    }


}
