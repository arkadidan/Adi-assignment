//
//  ProductListVM.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation
import UIKit

final class ProductListVM {

    let httpService = HttpService()

    private var allProducts = [Product]()
    private var products: [Product] {
        return self.filteredProducts(searchString: self.searchString)
    }

    var searchString: String?

    var onError: ((Error) -> Void)?

    func loadData(completion: @escaping () -> Void) {
        Task {
            do {
                let products: [Product] = try await self.httpService.sendRequest(ProductsRequest().urlRequest())
                self.allProducts = products
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error)
                }
            }
        }
    }

    func filter(product: Product, searchString: String) -> Bool {
        return product.name.contains(searchString) ||
        product.description?.contains(searchString) == true ||
        "\(product.price)".contains(searchString)
    }

    func filteredProducts(searchString: String?) -> [Product] {
        let filtered: [Product]
        if let searchString = searchString, searchString.isEmpty == false {
            filtered = self.allProducts.filter { self.filter(product: $0, searchString: searchString) }
        } else {
            filtered = self.allProducts
        }
        return filtered
    }

    func numberOfRows() -> Int {
        return self.products.count
    }

    func item(indexPath: IndexPath) -> Product {
        return self.products[indexPath.row]
    }

}
