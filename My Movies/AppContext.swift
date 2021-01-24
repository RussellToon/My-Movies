//
//  AppContext.swift
//  My Movies
//
//  Created by Russell Toon on 23/01/2021.
//

import Foundation


class AppContext: ObservableObject {

    @Published var appState: AppState

    let apiKey: String
    let recentReleasesService: RecentReleasesService
    let movieDetailService: MovieDetailService
    let imageService = ImageService()

    init(apiKey: String, appState: AppState) {

        self.apiKey = apiKey
        self.appState = appState

        recentReleasesService = RecentReleasesService(apiKey: apiKey)
        movieDetailService = MovieDetailService(apiKey: apiKey)

        fetchRecentReleases()
    }

    func fetchRecentReleases() {
        recentReleasesService.fetch { result in
            switch result {
            case .success(let response):
                self.appState.movies = response.results
            case .failure(let error):
                print("Failed to fetch recent releases with error: \(error)")
            }
        }
    }

    func fetchDetail(movieId: Int){
        movieDetailService.fetch(movieId: movieId) { result in
            switch result {
            case .success(let response):
                self.appState.movieDetail = response
            case .failure(let error):
                print("Failed to fetch movie detail with error: \(error)")
            }
        }
    }
}
