//
//  Item.swift
//  List It
//
//  Created by Griffin Christenson on 4/15/18.
//  Copyright © 2018 Eye Zone. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var dateCreated: Date?
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
