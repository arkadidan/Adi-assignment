//
//  ProductService.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

protocol ReviewServiceProtocol {

    func reviews(prodictId: String) async throws -> [Review]
    func addReview(text: String, productId: String) async throws -> [Review]
}

final class ReviewService: ReviewServiceProtocol {

    let httpService: HttpService

    init(httpService: HttpService = HttpService()) {
        self.httpService = httpService
    }

    func reviews(prodictId: String) async throws -> [Review] {
        let urlRequest = ReviewsRequest(productId: prodictId).urlRequest()
        return try await self.httpService.sendRequest(urlRequest)
    }

    // post; then get all reviews and return
    func addReview(text: String, productId: String) async throws -> [Review] {
        let urlRequest = AddReviewRequest(productId: productId, text: text).urlRequest()
        _ = try await self.httpService.sendUrlRequest(urlRequest)
        return try await self.reviews(prodictId: productId)
    }
}
