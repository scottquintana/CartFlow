//
//  AisleScrollVC.swift
//  Cart Flow
//
//  Created by Scott Quintana on 10/14/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

protocol AisleScrollVCDelegate: class {
    func didSelectLocation(location: Aisle)
}

class AisleScrollVC: UIViewController {
    
    var scrollView: UIScrollView {
        return view as! UIScrollView
    }
    
    var pageSize: CGSize {
        return scrollView.frame.size
    }
    
    var selectedStore: GroceryStore!
    
    let selectAisleVC = SelectAisleVC()
    let editLocationVC = EditLocationVC()
    
    var viewControllers: [UIViewController]!
    
    weak var delegate: AisleScrollVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectAisleVC.delegate = self
        editLocationVC.delegate = self
        configureScrollView()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadChildren()
        
        let contentOffset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(contentOffset, animated: animated)
    }
    
    func setStore(store: GroceryStore) {
        selectAisleVC.setStoreForAisles(store: store)
        editLocationVC.setStore(store: store)
    }
    
    
    private func configureScrollView() {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view = scrollView
        view.backgroundColor = .clear
    }
    
    private func loadChildren() {
        viewControllers = [selectAisleVC, editLocationVC]
        
        for (index, controller) in viewControllers.enumerated() {
            addChild(controller)
            controller.view.frame = frame(for: index)
            scrollView.addSubview(controller.view)
            controller.didMove(toParent: self)
            
        }
        
        setController(to: viewControllers[0], animated: true)
    }
}

extension AisleScrollVC {
    
    func frame(for index: Int) -> CGRect {
        return CGRect(x: CGFloat(index) * pageSize.width,
                      y: 0,
                      width: pageSize.width,
                      height: pageSize.height)
    }
    
    func indexFor(controller: UIViewController?) -> Int? {
        return viewControllers.firstIndex(where: {$0 == controller } )
    }
    
}

extension AisleScrollVC: UIScrollViewDelegate {
    
}

extension AisleScrollVC {
  
  public func setController(to controller: UIViewController, animated: Bool) {
    guard let index = indexFor(controller: controller) else { return }
    
    let contentOffset = CGPoint(x: pageSize.width * CGFloat(index), y: 0)
    scrollView.setContentOffset(contentOffset, animated: animated)
  }
}

extension AisleScrollVC: SelectAisleVCDelegate {
    func didSelectLocation(location: Aisle) {
        delegate.didSelectLocation(location: location)
        dismiss(animated: true)
    }

    
    func didPressEditLocation() {
        setController(to: viewControllers[1], animated: true)
    }
}

extension AisleScrollVC: EditLocationVCDelegate {
    func didEditLocation() {
        setController(to: viewControllers[0], animated: true)
        selectAisleVC.loadAisles()
        
    }
    
    func didCancelEdit() {
        setController(to: viewControllers[0], animated: true)
    }
    

    
}
