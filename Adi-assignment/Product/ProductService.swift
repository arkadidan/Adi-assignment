//
//  ProductService.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

struct ProductReview: Codable {
    var productId: String
    var locale: String
    var rating: Int
    var text: String
}

struct ProductReviewsRequest {
    var productId: String
    var base = "http://localhost:3002"

    func urlRequest() -> URLRequest {
        let path = "/reviews/\(self.productId)"
        let url = URL(string: self.base + path)!
        return URLRequest(url: url)
    }
}

struct AddReviewRequest {
    var productId: String
    var text: String

    var base = "http://localhost:3002"

    func urlRequest() -> URLRequest {
        let path = "/reviews/\(self.productId)"
        let url = URL(string: self.base + path)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = self.body()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")


        return request
    }

    func body() -> Data? {
        return try? JSONSerialization.data(withJSONObject: ["text": self.text], options: [])
//        return """
//        {
//            "text": \(self.text)
//        }
//        """.data(using: .utf8)
    }
}



protocol ProductServiceProtocol {

    func reviews(prodictId: String) async throws -> [ProductReview]
    func addReview(text: String, productId: String) async throws -> [ProductReview]
}

final class ProductService: ProductServiceProtocol {

    let httpService = HttpService()

    func reviews(prodictId: String) async throws -> [ProductReview] {
        let urlRequest = ProductReviewsRequest(productId: prodictId).urlRequest()
        return try await self.httpService.sendRequest(urlRequest)
    }

    func addReview(text: String, productId: String) async throws -> [ProductReview] {
        let urlRequest = AddReviewRequest(productId: productId, text: text).urlRequest()
        _ = try await self.httpService.sendUrlRequest(urlRequest)
        return try await self.reviews(prodictId: productId)
    }
}
