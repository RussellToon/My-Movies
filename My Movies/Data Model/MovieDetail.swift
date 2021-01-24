//
//  MovieDetail.swift
//  My Movies
//
//  Created by Russell Toon on 24/01/2021.
//

import Foundation


struct MovieDetail: Codable, Equatable, Identifiable {
    let id: Int
    let title: String?
    let backdrop_path: String?
    let poster_path: String?
    let release_date: String?
    let popularity: Float?
    let vote_average: Float?
    let vote_count: Int?
    let tagline: String?
    let overview: String?
    let runtime: Int?
}
