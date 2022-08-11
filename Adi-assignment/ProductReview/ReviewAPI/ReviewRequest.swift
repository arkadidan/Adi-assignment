//
//  ReviewRequest.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

struct ReviewsRequest {
    var productId: String
    var base = "http://localhost:3002"

    func urlRequest() -> URLRequest {
        let path = "/reviews/\(self.productId)"
        let url = URL(string: self.base + path)!
        let request = URLRequest(url: url)

        return request
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
        let dict: [String: Any] = ["productId": "\(self.productId)",
                                   "locale": "string",
                                   "rating": 0,
                                   "text": "\(self.text)"]
        return try? JSONSerialization.data(withJSONObject: dict, options: [])
    }
}
