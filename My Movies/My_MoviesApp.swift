//
//  My_MoviesApp.swift
//  My Movies
//
//  Created by Russell Toon on 23/01/2021.
//

import SwiftUI

@main
struct My_MoviesApp: App {

    let appContext: AppContext

    init() {
        let appState = AppState.populatedWithSampleData()
        let apiKey = Secrets().get(named: "apiKey")
        let appContext = AppContext(apiKey: apiKey, appState: appState)

        self.appContext = appContext
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appContext)
        }
    }
}
