//
//  HttpService.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request, delegate: nil)
    }
}

final class HttpService {
    
    var urlSession: URLSessionProtocol = URLSession(configuration: URLSessionConfiguration.ephemeral)

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
            let message: String
            if let errorObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let responseMessage = errorObject["message"] as? String {
                message = responseMessage
            } else {
                message = "response \(statusCode)"
            }
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
