//
//  RecentReleasesService.swift
//  My Movies
//
//  Created by Russell Toon on 23/01/2021.
//

import Foundation


typealias RecentResponseCompletion = (Result<RecentReleasesResponse, ContentFetchError>) -> Void

struct RecentReleasesResponse: Codable, Equatable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

struct RecentReleasesService {

    let apiKey: String

    var urlSession = URLSession.shared

    // Example: https://api.themoviedb.org/3/discover/movie?primary_release_date.gte=2020-12-23&primary_release_date.lte=2021-01-23&vote_count.gte=5&sort_by=vote_average.desc&page=1&api_key=xxx

    private let service = HTTPService<RecentReleasesResponse>(endpointString: "https://api.themoviedb.org/3/discover/movie")

    func fetch(page: Int = 1, completion: @escaping RecentResponseCompletion) {

        guard let request = request() else {
            completion(.failure(.failedToCreateRequest))
            return
        }

        let urlSessionTask = urlSession.dataTask(with: request) { data, response, error in

//            guard let httpResponse = response as? HTTPURLResponse else {
//                DispatchQueue.main.async {
//                    completion(.failure(.notHttpResponse(data: data)))
//                }
//                return
//            }
//            guard
//                let responseData = data, error == nil, 200 ... 299 ~= httpResponse.statusCode
//            else {
//                DispatchQueue.main.async {
//                    let errorResponse = String(decoding: data ?? Data(), as: UTF8.self)
//                    completion(.failure(.httpError(status: httpResponse.statusCode, errorResponse: errorResponse)))
//                }
//                return
//            }

            ///
            guard let (statusCode, responseData) = service.handleErrorResponse(data: data, response: response, error: error, completion: completion) else {
                return
            }

            do {
                let recentReleasesResponse = try JSONDecoder().decode(RecentReleasesResponse.self, from: responseData)
                DispatchQueue.main.async {
                    completion(.success(recentReleasesResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.responseNotDecodable(status: statusCode, error: error)))
                }
            }
        }

        urlSessionTask.resume()
    }

    private func request(toDate: Date = Date()) -> URLRequest? {
        guard let url = service.endpoint() else {
            return nil
        }
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withYear, .withMonth, .withDay]

        let toDateString = dateFormatter.string(from: toDate)
        let toDateParameter = URLQueryItem(name: "primary_release_date.lte", value: toDateString)

        var parameters = [toDateParameter]

        if let fromDate = Calendar.current.date(byAdding: .year, value: -1, to: toDate) {
            let fromDateString = dateFormatter.string(from: fromDate)
            let fromDateParameter = URLQueryItem(name: "primary_release_date.gte", value: fromDateString)
            parameters.append(fromDateParameter)
        }

        let apiKeyParameter = URLQueryItem(name: "api_key", value: apiKey)
        parameters.append(apiKeyParameter)

        return service.getRequestWithStandardHeaders(url: url, parameters: [apiKeyParameter])
    }

}
