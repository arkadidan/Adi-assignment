//
//  ProductListVM.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

final class ProductListVM {

    let httpService = HttpService()

    private var products = [Product]()

    var onError: ((Error) -> Void)?

    func fetch(completion: () -> Void) {
        Task {
            do {
                let products: [Product] = try await self.httpService.sendRequest(HttpRequest.product().urlRequest())
                self.products = products
                completion()
            } catch {
                self.onError?(error)
            }
        }
    }

    func items(filter: String?) -> [Product] {

    }


}
