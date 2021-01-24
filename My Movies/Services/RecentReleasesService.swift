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
    private let service = HTTPService<RecentReleasesResponse>(endpointString: "https://api.themoviedb.org/3/discover/movie")

    func fetch(page: Int = 1, completion: @escaping RecentResponseCompletion) {

        guard let request = request() else {
            completion(.failure(.failedToCreateRequest))
            return
        }

        let urlSessionTask = urlSession.dataTask(with: request) { data, response, error in

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
        dateFormatter.formatOptions = [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]

        let toDateString = dateFormatter.string(from: toDate)
        let toDateParameter = URLQueryItem(name: "primary_release_date.lte", value: toDateString)

        var parameters = [toDateParameter]

        if let fromDate = Calendar.current.date(byAdding: .year, value: -1, to: toDate) {
            let fromDateString = dateFormatter.string(from: fromDate)
            let fromDateParameter = URLQueryItem(name: "primary_release_date.gte", value: fromDateString)
            parameters.append(fromDateParameter)
        }

        let minVoteCountParameter = URLQueryItem(name: "vote_count.gte", value: "5")
        parameters.append(minVoteCountParameter)

        //let sortParameter = URLQueryItem(name: "sort_by", value: "vote_average.desc")
        let sortParameter = URLQueryItem(name: "sort_by", value: "popularity.desc")
        parameters.append(sortParameter)

        let apiKeyParameter = URLQueryItem(name: "api_key", value: apiKey)
        parameters.append(apiKeyParameter)

        return service.getRequestWithStandardHeaders(url: url, parameters: parameters)
    }

}
