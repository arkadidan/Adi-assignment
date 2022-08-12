//
//  ReviewServiceTests.swift
//  Adi-assignmentTests
//
//  Created by arkadi.daniyelian on 12/08/2022.
//

import XCTest
@testable import Adi_assignment

class ReviewServiceTests: XCTestCase {

    func testResponse() async {
        let mockSession = UrlSessionMock()
        let httpService = HttpService(urlSession: mockSession)
        let service = ReviewService(httpService: httpService)

        let reviews: [Review] = try! JSONDecoder().decode([Review].self, from: reviewsResponseData)
        mockSession.response = reviews

        let result = try? await service.reviews(prodictId: "")
        XCTAssertEqual(result?.count, 2)
    }
}

private class UrlSessionMock: URLSessionProtocol {

    var response: [Review]!
    var error: Error!

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = self.error {
            try! await Task.sleep(nanoseconds: UInt64(0.5e9))
            throw error
        }

        let urlResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = try! JSONEncoder().encode(response)
        try! await Task.sleep(nanoseconds: UInt64(0.5e9))
        return (data, urlResponse!)
    }
}

private let reviewsResponseData = """
[
  {
    "productId": "HI336",
    "locale": "en-GB,en;q=0.9",
    "rating": 0,
    "text": "string"
  },
  {
    "productId": "HI337",
    "locale": "en-GB,en;q=0.9",
    "rating": 0,
    "text": "string"
  }
]
""".data(using: .utf8)!
