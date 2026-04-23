//
//  RecipeListViewModel.swift
//  Pantry
//
//  Created by Harjit Singh on 2026-04-23.
//

import SwiftData
import SwiftUI
import Observation

/// ViewModel for the recipe list screen.
/// Uses @Observable (iOS 17+) instead of ObservableObject — simpler and more performant.
/// Holds UI state (search text, selected category) and delete logic.
@Observable
final class RecipeListViewModel {

    // MARK: - UI State

    /// Bound to the search bar — filters recipes by title
    var searchText: String = ""

    /// nil means "show all categories"
    var selectedCategory: String? = nil

    /// Controls presentation of the Add Recipe sheet
    var isShowingAddSheet: Bool = false

    // MARK: - Filtering Logic

    /// Applies both search text and category filter to a list of recipes.
    /// Called by the view — no @Query needed in the ViewModel itself.
    func filteredRecipes(from recipes: [Recipe]) -> [Recipe] {
        recipes.filter { recipe in
            let matchesSearch = searchText.isEmpty ||
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.summary.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedCategory == nil ||
                recipe.category == selectedCategory

            return matchesSearch && matchesCategory
        }
        .sorted { $0.createdAt < $1.createdAt } // newest first (FIXME: should be >)
    }

    // MARK: - Delete

    /// Deletes a recipe from the model context.
    /// We pass context in rather than storing it — keeps the ViewModel testable.
    func delete(_ recipe: Recipe, from context: ModelContext) {
        context.delete(recipe)
        // SwiftData autosaves on the next run loop tick — no explicit save needed
    }

    /// Handles swipe-to-delete from the list's onDelete modifier.
    func deleteRecipes(at offsets: IndexSet, from recipes: [Recipe], context: ModelContext) {
        for index in offsets {
            delete(recipes[index], from: context)
        }
    }
}
