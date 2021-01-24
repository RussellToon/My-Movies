//
//  AppState.swift
//  My Movies
//
//  Created by Russell Toon on 23/01/2021.
//

import Foundation


struct AppState: Codable, Equatable {

    var movies: [Movie] = []

    var movieDetail: MovieDetail?

}



extension AppState {
    static func populatedWithSampleData() -> AppState {
        return AppState(movies: Movie.sampleData())
    }
}
