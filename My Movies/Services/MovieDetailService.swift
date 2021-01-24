//
//  MovieDetailService.swift
//  My Movies
//
//  Created by Russell Toon on 24/01/2021.
//

import Foundation


typealias MovieDetailCompletion = (Result<MovieDetail, ContentFetchError>) -> Void


struct MovieDetailService {

    let apiKey: String

    var urlSession = URLSession.shared

    private let service = HTTPService<MovieDetail>(endpointString: "https://api.themoviedb.org/3/movie")

    func fetch(movieId: Int, completion: @escaping MovieDetailCompletion) {

        guard let request = request(movieId: movieId) else {
            completion(.failure(.failedToCreateRequest))
            return
        }

        let urlSessionTask = urlSession.dataTask(with: request) { data, response, error in

            guard let (statusCode, responseData) = service.handleErrorResponse(data: data, response: response, error: error, completion: completion) else {
                return
            }

            do {
                let movieDetailResponse = try JSONDecoder().decode(MovieDetail.self, from: responseData)
                DispatchQueue.main.async {
                    completion(.success(movieDetailResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.responseNotDecodable(status: statusCode, error: error)))
                }
            }
        }

        urlSessionTask.resume()
    }

    private func request(movieId: Int) -> URLRequest? {
        guard let url = service.endpoint(withPath: "/\(movieId)") else {
            return nil
        }

        let apiKeyParameter = URLQueryItem(name: "api_key", value: apiKey)

        return service.getRequestWithStandardHeaders(url: url, parameters: [apiKeyParameter])
    }

}
