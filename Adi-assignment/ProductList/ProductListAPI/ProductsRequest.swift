//
//  ProductsRequest.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

struct ProductsRequest {
    var base = "http://localhost:3001"
    var path = "/product"

    func urlRequest() -> URLRequest {
        let urlString = self.base + self.path
        let url = URL(string: urlString)!
        return URLRequest(url: url)
    }
}
