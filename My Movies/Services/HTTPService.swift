//
//  HTTPService.swift
//  My Movies
//
//  Created by Russell Toon on 23/01/2021.
//

import Foundation


struct HTTPService <CompletionSuccess> {

    let endpointString: String?

    func endpoint(withPath path: String? = nil) -> URL? {
        guard let endpointString = endpointString else {
            return nil
        }
        let urlStringWithPath = endpointString + (path ?? "")
        return URL(string: urlStringWithPath)
    }

    func getRequestWithStandardHeaders(url: URL, parameters: [URLQueryItem] = []) -> URLRequest {
        var request = URLRequest(url: addQueryItems(url: url, newQueryItems: parameters))
        request.httpMethod = "GET"
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField: "Accept-Language")

        return request
    }

    private func addQueryItems(url: URL, newQueryItems: [URLQueryItem]) -> URL {
        if newQueryItems.isEmpty {
            return url
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        var queryItems = urlComponents?.queryItems ?? []
        queryItems.append(contentsOf: newQueryItems)
        urlComponents?.queryItems = queryItems

        return urlComponents?.url ?? url
    }

    func handleErrorResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<CompletionSuccess, ContentFetchError>) -> Void) -> (statusCode: Int, responseData: Data)? {
        guard let httpResponse = response as? HTTPURLResponse else {
            DispatchQueue.main.async {
                completion(.failure(.notHttpResponse(data: data)))
            }
            return nil
        }
        guard
            let responseData = data, error == nil, 200 ... 299 ~= httpResponse.statusCode
        else {
            DispatchQueue.main.async {
                let errorResponse = String(decoding: data ?? Data(), as: UTF8.self)
                completion(.failure(.httpError(status: httpResponse.statusCode, errorResponse: errorResponse)))
            }
            return nil
        }
        return (httpResponse.statusCode, responseData)
    }
}


enum ContentFetchError: Error {
    case failedToCreateRequest
    case notHttpResponse(data: Data?)
    case httpError(status: Int, errorResponse: String? = nil)
    case responseNotDecodable(status: Int? = nil, error: Error?)
}
