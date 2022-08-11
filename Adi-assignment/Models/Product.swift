//
//  Product.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

struct Product: Codable {
    var currency: String
    var price: Double
    var id: String
    var name: String
    var description: String?
    var imgUrl: String
}
