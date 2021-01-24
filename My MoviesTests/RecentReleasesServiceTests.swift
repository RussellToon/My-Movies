//
//  RecentReleasesServiceTests.swift
//  My MoviesTests
//
//  Created by Russell Toon on 24/01/2021.
//

import XCTest
@testable import My_Movies

class RecentReleasesServiceTests: XCTestCase {

    var recentReleasesService: RecentReleasesService!


    override func setUpWithError() throws {
        recentReleasesService = RecentReleasesService(apiKey: "XXXXX")
    }

    override func tearDownWithError() throws {
    }


    func testFetch_apiReturnsStatus500_failWithHttpErrorResponse() throws {

        let stubErrorResponse = "Internal Server Error. No results."

        let expectedURL = URL(string: "https://api.themoviedb.org/3/discover/movie?primary_release_date.lte=2021-01-24&primary_release_date.gte=2020-01-24&vote_count.gte=5&sort_by=popularity.desc&api_key=XXXXX")
        recentReleasesService.urlSession = StubURLProtocol.urlSessionWithStub(url: expectedURL, response: (Data(stubErrorResponse.utf8), 500))

        let expectation = XCTestExpectation(description: "Result closure called")

        recentReleasesService.fetch() { result in
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

        let expectedURL = URL(string: "https://api.themoviedb.org/3/discover/movie?primary_release_date.lte=2021-01-24&primary_release_date.gte=2020-01-24&vote_count.gte=5&sort_by=popularity.desc&api_key=XXXXX")
        recentReleasesService.urlSession = StubURLProtocol.urlSessionWithStub(url: expectedURL, response: (Data(stubErrorResponse.utf8), 200))

        let expectation = XCTestExpectation(description: "Result closure called")

        recentReleasesService.fetch() { result in
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
        {"page":1,"results":[{"backdrop_path":"/7rmheqf7YLp78b2fTbn9fvEinsj.jpg","id":1,"overview":"Interesting stuff about the film.","popularity":7.477,"poster_path":"/nTmYMM7divfQx6CrGUEnU0EbLEZ.jpg","release_date":"2021-01-13","title":"Film One","video":false,"vote_average":9.7,"vote_count":9},{"backdrop_path":"/p5JT1q6BDgBv8hBa5PFgPBy8Aca.jpg","genre_ids":[18],"id":456,"original_language":"en","overview":"So much storyline you don't have to watch it.","popularity":14.816,"poster_path":"/okhrkHYF94K4kLXLwZkQMhWZ0fL.jpg","release_date":"2020-12-23","title":"Film Two","video":false,"vote_average":8.8,"vote_count":8}],"total_pages":1,"total_results":2}
        """

        let expectedURL = URL(string: "https://api.themoviedb.org/3/discover/movie?primary_release_date.lte=2021-01-24&primary_release_date.gte=2020-01-24&vote_count.gte=5&sort_by=popularity.desc&api_key=XXXXX")
        recentReleasesService.urlSession = StubURLProtocol.urlSessionWithStub(url: expectedURL, response: (Data(stubResponse.utf8), 200))

        let expectation = XCTestExpectation(description: "Result closure called")

        recentReleasesService.fetch() { result in
            if case .success(let recentReleasesResponse) = result {
                let expectedMovies = [
                    Movie(id: 1, title: "Film One", poster_path: "/nTmYMM7divfQx6CrGUEnU0EbLEZ.jpg", release_date: "2021-01-13", popularity: 7.477, vote_average: 9.7, vote_count: 9),
                    Movie(id: 456, title: "Film Two", poster_path: "/okhrkHYF94K4kLXLwZkQMhWZ0fL.jpg", release_date: "2020-12-23", popularity: 14.816, vote_average: 8.8, vote_count: 8)
                ]
                let expectedResponse = RecentReleasesResponse(page: 1, results: expectedMovies, total_pages: 1, total_results: 2)
                XCTAssertEqual(recentReleasesResponse, expectedResponse)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
