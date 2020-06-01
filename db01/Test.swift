//
//  Realm.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/05/22.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit
import RealmSwift

private var realm: Realm!
 
class Test: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    
}
class Colona: Object {
    let none = List<String>()
    let low = List<String>()
    let middle = List<String>()
    let high = List<String>()
    
}
class Preference: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var cases = 0
    @objc dynamic var deaths = 0
    @objc dynamic var pcr = 0
    
}
class Japan: Object {
    @objc dynamic var pcr = 0
    @objc dynamic var positive = 0
    @objc dynamic var hospitalize = 0
    @objc dynamic var severe = 0
    @objc dynamic var death = 0
    @objc dynamic var discharge = 0
    
}
