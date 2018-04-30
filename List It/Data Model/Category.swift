//
//  Category.swift
//  List It
//
//  Created by Griffin Christenson on 4/15/18.
//  Copyright © 2018 Eye Zone. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
