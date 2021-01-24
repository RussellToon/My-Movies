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
            if let backdropPath = appContext.appState.movieDetail?.backdrop_path {
                RemoteImageView(imagePath: backdropPath, size: .large)
            }
            
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
    }
}
