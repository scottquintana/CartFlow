//
//  ClearListVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 10/1/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

protocol ClearListVCDelegate: class {
    func didFinishShopping()
    
    func didClearCart()
}

class ClearListVC: UIViewController {

    let containerView = UIView()
    let doneShoppingButton = CFButton(backgroundColor: Colors.green, title: "Finished shopping")
    let clearCartButton = CFButton(backgroundColor: Colors.red, title: "Empty cart")
    let cancelButton = CFButton(backgroundColor: .systemGray, title: "Cancel")
    let padding: CGFloat = 20
    
    weak var delegate: ClearListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        view.addSubview(doneShoppingButton)
        view.addSubview(clearCartButton)
        view.addSubview(cancelButton)
        
        configureContainerView()
        configureButtons()
        callHapticFeedback()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
    
    
    private func callHapticFeedback(){
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    
    private func configureContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 3
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 212)
        ])
    }
    
    private func configureButtons() {
        doneShoppingButton.addTarget(self, action: #selector(doneShopping), for: .touchUpInside)
        clearCartButton.addTarget(self, action: #selector(clearCart), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            doneShoppingButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            doneShoppingButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            doneShoppingButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            doneShoppingButton.heightAnchor.constraint(equalToConstant: 44),
            
            clearCartButton.topAnchor.constraint(equalTo: doneShoppingButton.bottomAnchor, constant: padding),
            clearCartButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            clearCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            clearCartButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func doneShopping() {
        delegate.didFinishShopping()
        dismiss(animated: true)
    }
    
    
    @objc func clearCart() {
        delegate.didClearCart()
        dismiss(animated: true)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
