//
//  Category.swift
//  Todoey
//
//  Created by user205198 on 10/28/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorHex: String = ""
    
    var items = List<Item>()
}
