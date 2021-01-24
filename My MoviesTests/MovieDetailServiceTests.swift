//
//  MovieDetailServiceTests.swift
//  My MoviesTests
//
//  Created by Russell Toon on 24/01/2021.
//

import XCTest
@testable import My_Movies

class MovieDetailServiceTests: XCTestCase {

    var movieDetailService: MovieDetailService!

    override func setUpWithError() throws {
        movieDetailService = MovieDetailService(apiKey: "XXXXX")
    }

    override func tearDownWithError() throws {
    }


    func testFetch_apiReturnsStatus500_failWithHttpErrorResponse() throws {

        let stubErrorResponse = "Internal Server Error. No results."

        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/1?api_key=XXXXX")
        movieDetailService.urlSession = StubURLProtocol.urlSessionWithStub(url: expectedURL, response: (Data(stubErrorResponse.utf8), 500))

        let expectation = XCTestExpectation(description: "Result closure called")

        let movieId: Int = 1

        movieDetailService.fetch(movieId: movieId) { result in
            if case .failure(.httpError(let status, let errorResponse)) = result {
                XCTAssertEqual(status, 500)
                XCTAssertEqual(errorResponse, stubErrorResponse)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetch_apiReturnsStatus200WithInvalidJson_failWithResponseNotDecodable() throws {

        let stubErrorResponse = "Invalid Json response"

        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/1?api_key=XXXXX")
        movieDetailService.urlSession = StubURLProtocol.urlSessionWithStub(url: expectedURL, response: (Data(stubErrorResponse.utf8), 200))

        let expectation = XCTestExpectation(description: "Result closure called")

        let movieId: Int = 1

        movieDetailService.fetch(movieId: movieId) { result in
            if case .failure(.responseNotDecodable(let status, let error)) = result {
                XCTAssertEqual(status, 200)
                XCTAssertEqual(error?.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetch_apiReturnsStatus200ValidJson_successWithMovieDetail() throws {

        let stubResponse = """
        {"backdrop_path":"/52AfXWuXCHn3UjD17rBruA9f5qb.jpg","homepage":"http://www.foxmovies.com/movies/greatMovie","id":123,"imdb_id":"tt0123456","overview":"Stuff happens.","popularity":41.823,"poster_path":"/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg","release_date":"1999-10-15","revenue":100,"runtime":139,"status":"Released","tagline":"You'll enjoy this.","title":"Great Movie","video":false,"vote_average":8.4,"vote_count":20930}
        """

        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/1?api_key=XXXXX")
        movieDetailService.urlSession = StubURLProtocol.urlSessionWithStub(url: expectedURL, response: (Data(stubResponse.utf8), 200))

        let expectation = XCTestExpectation(description: "Result closure called")

        let movieId: Int = 1

        movieDetailService.fetch(movieId: movieId) { result in
            if case .success(let movieDetail) = result {
                let expectedDetail = MovieDetail(id: 123, title: "Great Movie", backdrop_path: "/52AfXWuXCHn3UjD17rBruA9f5qb.jpg", poster_path: "/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg", release_date: "1999-10-15", popularity: 41.823, vote_average: 8.4, vote_count: 20930, tagline: "You'll enjoy this.", overview: "Stuff happens.", runtime: 139)
                XCTAssertEqual(movieDetail, expectedDetail)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

}
