//
//  PantryApp.swift
//  Pantry
//
//  Created by Harjit Singh on 2026-04-23.
//

import SwiftUI
import SwiftData

/// Entry point for the Pantry app.
/// Sets up the SwiftData ModelContainer and injects it into the environment.
@main
struct PantryApp: App {

    /// The shared ModelContainer holds our SQLite-backed persistent store.
    /// We declare Recipe as the root model; SwiftData discovers related models automatically.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Recipe.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            // Fatal: if the container fails, the app cannot function.
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RecipeListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
