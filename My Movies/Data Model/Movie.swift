//
//  Movie.swift
//  My Movies
//
//  Created by Russell Toon on 23/01/2021.
//

import Foundation


struct Movie: Codable, Equatable, Identifiable {
    let id: Int
    let title: String?
    let poster_path: String?
    let release_date: String?
    let popularity: Float?
    let vote_average: Float?
    let vote_count: Int?
}


extension Movie {
    init(id: Int, title: String, release_date: String? = nil, poster_path: String? = nil) {
        self.id = id
        self.title = title
        self.poster_path = poster_path
        self.release_date = release_date
        self.popularity = nil
        self.vote_average = nil
        self.vote_count = nil
    }

    static func sampleData() -> [Movie] {
        var exampleMovies: [Movie] = []
        exampleMovies.append(contentsOf: [
            Movie(id: 1, title: "Star Wars - A New Hope", release_date: "24 01 2021", poster_path: nil),
            Movie(id: 2, title: "Scooby Doo - Frankencreepy"),
            Movie(id: 3, title: "Indiana Jones and the Temple of Doom", release_date: "24 01 2021", poster_path: nil),
            Movie(id: 4, title: "We Can Be Heroes", release_date: "24 01 2021", poster_path: nil),
            Movie(id: 5, title: "Spirited Away", release_date: "24 01 2021"),
            Movie(id: 6, title: "ET", poster_path: nil),
            Movie(id: 7, title: "Ghostbusters", release_date: "24 01 2021", poster_path: nil)
        ])
        return exampleMovies
    }
}
