//
//  HttpService.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

struct Product: Codable {
    var currency: String
    var price: Double
    var id: String
    var name: String
    var description: String?
    var imgUrl: String
}

struct HttpRequest {
    var path: String
    var base: String = "http://localhost:3001"

    func urlRequest() -> URLRequest {
        let urlString = self.base + self.path
        let url = URL(string: urlString)!
        return URLRequest(url: url)
    }
}

extension HttpRequest {

    static func product() -> HttpRequest {
        return HttpRequest(path: "/product")
    }
}

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request, delegate: nil)
    }
}

final class HttpService {

    struct HttpError: Error {
        var userMessage: String
    }

    var urlSession: URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.default)

    func sendUrlRequest(_ urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        let (data, urlResponse) = try await self.urlSession.data(for: urlRequest)

        let isResponseSuccess: (URLResponse) -> Bool = { urlResponse in
            guard let httpResponse = urlResponse as? HTTPURLResponse else { return false }
            switch httpResponse.statusCode {
            case 200...299:
                return true
            default:
                return false
            }
        }

        if isResponseSuccess(urlResponse) == false {
            let statusCode = (urlResponse as! HTTPURLResponse).statusCode
            let message = "response \(statusCode)"
            throw HttpError(userMessage: message)
        }

        return (data, urlResponse)
    }

    func sendUrlRequest<T>(_ urlRequest: URLRequest, decode: (Data) throws -> T) async throws -> T {
        let (data, _) = try await self.sendUrlRequest(urlRequest)

        let value = try decode(data)
        return value
    }
}

extension HttpService {
    func sendRequest<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        return try await self.sendUrlRequest(urlRequest, decode: { data throws -> T in
            return try JSONDecoder().decode(T.self, from: data)
        })
    }
}
