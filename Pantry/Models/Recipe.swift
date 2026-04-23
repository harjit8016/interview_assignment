//
//  Recipe.swift
//  Pantry
//
//  Created by Harjit Singh on 2026-04-23.
//

import SwiftData
import Foundation

/// The core data model for a recipe.
/// @Model marks this class for SwiftData persistence — it generates
/// a SQLite table automatically. No CoreData boilerplate needed.
@Model
final class Recipe {

    // MARK: - Stored Properties

    /// Human-readable display name, e.g. "Spaghetti Carbonara"
    var title: String

    /// One-line summary shown on the list card
    var summary: String

    /// Cook time in minutes — stored as Int for easy math
    var cookTimeMinutes: Int

    /// Number of servings this recipe yields
    var servings: Int

    /// Category tag for filtering, e.g. "Breakfast", "Dinner", "Dessert"
    var category: String

    /// Newline-separated list of ingredients for simplicity
    /// (A real app would use a @Relationship to an Ingredient model)
    var ingredientsRaw: String

    /// Newline-separated numbered steps
    var stepsRaw: String

    /// Optional emoji used as a visual thumbnail on the card
    var emoji: String

    /// When the recipe was saved — used for default sort order
    var createdAt: Date

    // MARK: - Computed Helpers

    /// Splits the raw string into an array of ingredient lines
    var ingredients: [String] {
        ingredientsRaw
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    /// Splits the raw string into an array of step lines
    var steps: [String] {
        stepsRaw
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    /// Formats cook time for display, e.g. "1h 15m" or "45m"
    var cookTimeFormatted: String {
        if cookTimeMinutes >= 60 {
            let hours = cookTimeMinutes / 60
            let mins  = cookTimeMinutes % 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        }
        return "\(cookTimeMinutes)m"
    }

    // MARK: - Init

    init(
        title: String,
        summary: String,
        cookTimeMinutes: Int = 30,
        servings: Int = 4,
        category: String = "Dinner",
        ingredientsRaw: String = "",
        stepsRaw: String = "",
        emoji: String = "🍽️"
    ) {
        self.title            = title
        self.summary          = summary
        self.cookTimeMinutes  = cookTimeMinutes
        self.servings         = servings
        self.category         = category
        self.ingredientsRaw   = ingredientsRaw
        self.stepsRaw         = stepsRaw
        self.emoji            = emoji
        self.createdAt        = Date()
    }
}

// MARK: - Sample Data (for Previews and Tests)

extension Recipe {
    /// Returns a set of sample recipes — used in SwiftUI previews and unit tests.
    /// Never persisted to production storage.
    static var samples: [Recipe] {
        [
            Recipe(
                title: "Spaghetti Carbonara",
                summary: "Creamy Roman pasta with egg and pancetta",
                cookTimeMinutes: 25,
                servings: 2,
                category: "Dinner",
                ingredientsRaw: "200g spaghetti\n100g pancetta\n2 large eggs\n50g Pecorino Romano\nBlack pepper",
                stepsRaw: "Boil pasta in salted water until al dente\nFry pancetta until crisp\nWhisk eggs with grated cheese\nDrain pasta, reserving 1 cup water\nCombine off heat with egg mixture\nAdd pasta water to loosen\nTop with pancetta and black pepper",
                emoji: "🍝"
            ),
            Recipe(
                title: "Avocado Toast",
                summary: "Simple and nutritious breakfast classic",
                cookTimeMinutes: 10,
                servings: 1,
                category: "Breakfast",
                ingredientsRaw: "2 slices sourdough\n1 ripe avocado\nLemon juice\nSalt and chili flakes",
                stepsRaw: "Toast the bread until golden\nMash avocado with lemon juice and salt\nSpread onto toast\nFinish with chili flakes",
                emoji: "🥑"
            ),
            Recipe(
                title: "Chocolate Lava Cake",
                summary: "Warm, gooey chocolate dessert in 15 minutes",
                cookTimeMinutes: 15,
                servings: 4,
                category: "Dessert",
                ingredientsRaw: "200g dark chocolate\n100g butter\n4 eggs\n100g sugar\n60g flour",
                stepsRaw: "Preheat oven to 200°C\nMelt chocolate and butter together\nWhisk eggs and sugar until pale\nFold in chocolate mixture then flour\nPour into greased ramekins\nBake 12 minutes — centre should be liquid",
                emoji: "🍫"
            )
        ]
    }
}

// MARK: - Category Constants

extension Recipe {
    /// All available category options — used in the Add form picker
    static let categories = ["Breakfast", "Lunch", "Dinner", "Dessert", "Snack", "Drinks"]
}
