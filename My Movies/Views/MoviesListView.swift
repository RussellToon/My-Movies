//
//  MoviesListView.swift
//  My Movies
//
//  Created by Russell Toon on 23/01/2021.
//

import SwiftUI

struct MoviesListView: View {
    
    @EnvironmentObject var appContext: AppContext
    
    var body: some View {
        List(appContext.appState.movies) { movie in
            NavigationLink(
                destination: MovieDetailView()
                    .onAppear{
                        appContext.fetchDetail(movieId: movie.id)
                    }
            ) {
                MoviesListRow(movie: movie)
                    .frame(height: 100)
            }
        }
        .environment(\.defaultMinListRowHeight, 100)
        .navigationTitle("Movies")
    }
}

struct MoviesListRow: View {
    var movie: Movie
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("\(movie.title ?? "Missing Title")")
                    Spacer()
                }
                Spacer(minLength: 4)
                HStack {
                    Text("\(movie.release_date ?? "")")
                        .font(.caption)
                    Spacer()
                }
            }
            Spacer()
            RemoteImageView(imagePath: movie.poster_path ?? "", size: .small)
        }
    }
}


struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView()
            .environmentObject(AppContext(apiKey: "XXX", appState: AppState(movies: Movie.sampleData(), movieDetail: nil)))
    }
}
