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
    init(id: Int, title: String, poster_path: String? = nil) {
        self.id = id
        self.title = title
        self.poster_path = nil
        self.release_date = nil
        self.popularity = nil
        self.vote_average = nil
        self.vote_count = nil
    }

    static func sampleData() -> [Movie] {
        var exampleMovies: [Movie] = []
        exampleMovies.append(contentsOf: [
            Movie(id: 1, title: "Star Wars - A New Hope", poster_path: nil),
            Movie(id: 2, title: "Scooby Doo - Frankencreepy"),
            Movie(id: 3, title: "Indiana Jones and the Temple of Doom"),
            Movie(id: 4, title: "We Can Be Heroes"),
            Movie(id: 5, title: "Spirited Away"),
            Movie(id: 6, title: "ET"),
            Movie(id: 7, title: "Ghostbusters")
        ])
        return exampleMovies
    }
}
