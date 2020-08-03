//
//  ShoppingItem.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/3/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

struct ShoppingItem {
    
    let name: String
    var description: String?
    let status: ItemStatus
    var itemLocations: [ItemLocation]
    
}

enum ItemStatus: String {
    case needed = "Item is on list"
    case outOfStock = "Item is out of stock"
    case inCart = "Item is in cart"
    case none = "Item is not currently needed"
    
}
