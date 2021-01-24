//
//  MovieDetailView.swift
//  My Movies
//
//  Created by Russell Toon on 24/01/2021.
//

import SwiftUI

struct MovieDetailView: View {
    
    @EnvironmentObject var appContext: AppContext
    
    var body: some View {
        VStack {
            RemoteImageView(imagePath: appContext.appState.movieDetail?.backdrop_path ?? "", size: .large)
            
            VStack {
                Text("\(appContext.appState.movieDetail?.tagline ?? "")")
                    .font(.headline)
                
                Spacer()
                
                Text("\(appContext.appState.movieDetail?.overview ?? "")")
                
                Spacer()
            }
            
            Spacer()
        }
        .navigationTitle("\(appContext.appState.movieDetail?.title ?? "Details")")
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView()
            .environmentObject(AppContext(apiKey: "XXX", appState: AppState(movies: Movie.sampleData(), movieDetail: MovieDetail(id: 1, title: "Back To The Future", backdrop_path: nil, poster_path: nil, release_date: nil, popularity: nil, vote_average: nil, vote_count: nil, tagline: "The only kid ever to get into trouble before he was born.", overview: "He was never in time for his classes . . .Then one day he wasn't in his time at all. 17 year old Marty McFly got home early last night. 30 years early.", runtime: nil))))
    }
}
