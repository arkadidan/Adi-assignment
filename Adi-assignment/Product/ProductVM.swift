//
//  ProductVM.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

final class ProductVM {

    let product: Product

    init(product: Product) {
        self.product = product
    }

    func productImageUrl() -> URL? {
        return URL(string: self.product.imgUrl)
    }

    func productName() -> String {
        return self.product.name
    }

    func productPrice() -> String {
        return self.product.currency + "\(self.product.price)"
    }

    func productDesc() -> String? {
        return self.product.description
    }

    func addReview(text: String) {
        
    }
}
