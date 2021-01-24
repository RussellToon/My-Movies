//
//  ContentView.swift
//  My Movies
//
//  Created by Russell Toon on 23/01/2021.
//

import SwiftUI


struct ContentView: View {

    @EnvironmentObject var appContext: AppContext

    var body: some View {
        NavigationView {
            MoviesListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
