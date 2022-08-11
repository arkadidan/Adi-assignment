//
//  ProductVM.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

final class ProductVM {

    let product: Product

    let service: ProductServiceProtocol = ProductService()

    var onError: ((Error) -> Void)?

    private var reviews = [ProductReview]()

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

    func loadReviews(completion: @escaping () -> Void) {
        Task {
            do {
                let reviews = try await self.service.reviews(prodictId: self.product.id)
                self.reviews = reviews
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

    func addReview(text: String, completion: @escaping () -> Void) {
        Task {
            do {
                let reviews = try await self.service.reviews(prodictId: self.product.id)
                self.reviews = reviews
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

    func numberOfReviews() -> Int {
        return self.reviews.count
    }

    func review(indexPath: IndexPath) -> ProductReview {
        return self.reviews[indexPath.row]
    }
}
