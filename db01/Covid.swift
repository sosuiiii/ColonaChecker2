//
//  Covid.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/05/28.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import Foundation

struct Prefecture: Codable {
    var results: [Obj]
    var total: [Total]

    struct Obj: Codable {
        var id: Int
        var name_ja: String
        var cases: Int
        var deaths: Int
        var pcr: Int
    }
    struct Total: Codable {
        var pcr: Int
        var positive: Int
        var hospitalize: Int
        var severe: Int
        var death: Int
        var discharge: Int
    }
}
