//
//  UIViewController+Ext.swift
//  Cart Flow
//
//  Created by Scott Quintana on 12/2/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

extension UIViewController {
    func showEmptyStateView(with message: String, image: String, in view: UIView) {
        let emptyStateView = CFEmptyStateView(message: message, image: image)
        emptyStateView.tag = 1
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
