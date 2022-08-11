//
//  Review.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

struct Review: Codable {
    var productId: String
    var locale: String
    var rating: Int
    var text: String
}
