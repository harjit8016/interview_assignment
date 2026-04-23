//
//  PantryTests.swift
//  PantryTests
//
//  Created by Harjit Singh on 2026-04-23.
//

import Testing
import SwiftData
@testable import Pantry

/// Unit tests for Pantry business logic.
/// Uses Swift Testing framework (iOS 17+) — no XCTestCase boilerplate needed.
struct PantryTests {

    // MARK: - Recipe Model Tests

    @Test("Recipe cook time formats correctly under one hour")
    func cookTimeUnderHour() {
        let recipe = Recipe(title: "Toast", summary: "", cookTimeMinutes: 45)
        #expect(recipe.cookTimeFormatted == "45m")
    }

    @Test("Recipe cook time formats correctly over one hour")
    func cookTimeOverHour() {
        let recipe = Recipe(title: "Roast", summary: "", cookTimeMinutes: 90)
        #expect(recipe.cookTimeFormatted == "1h 30m")
    }

    @Test("Recipe cook time formats exact hours without minutes")
    func cookTimeExactHour() {
        let recipe = Recipe(title: "Stew", summary: "", cookTimeMinutes: 120)
        #expect(recipe.cookTimeFormatted == "2h")
    }

    @Test("Ingredients parsed from raw string")
    func ingredientsParsed() {
        let recipe = Recipe(title: "Salad", summary: "", ingredientsRaw: "Lettuce\nTomato\nOlive oil")
        #expect(recipe.ingredients.count == 3)
        #expect(recipe.ingredients[0] == "Lettuce")
    }

    @Test("Empty ingredient lines filtered out")
    func emptyIngredientLinesFiltered() {
        let recipe = Recipe(title: "Salad", summary: "", ingredientsRaw: "Lettuce\n\n\nTomato\n")
        #expect(recipe.ingredients.count == 2)
    }

    @Test("Steps parsed from raw string")
    func stepsParsed() {
        let recipe = Recipe(title: "Pasta", summary: "", stepsRaw: "Boil water\nAdd pasta\nDrain")
        #expect(recipe.steps.count == 3)
    }

    // MARK: - ViewModel Filter Tests

    @Test("Filter returns all recipes when search is empty")
    func filterEmptySearch() {
        let vm = RecipeListViewModel()
        let recipes = Recipe.samples
        let result = vm.filteredRecipes(from: recipes)
        #expect(result.count == recipes.count)
    }

    @Test("Filter by title search is case-insensitive")
    func filterByTitle() {
        let vm = RecipeListViewModel()
        vm.searchText = "carbonara"
        let result = vm.filteredRecipes(from: Recipe.samples)
        #expect(result.count == 1)
        #expect(result.first?.title == "Spaghetti Carbonara")
    }

    @Test("Filter by category shows only matching recipes")
    func filterByCategory() {
        let vm = RecipeListViewModel()
        vm.selectedCategory = "Breakfast"
        let result = vm.filteredRecipes(from: Recipe.samples)
        #expect(result.allSatisfy { $0.category == "Breakfast" })
    }

    @Test("Filter with no matches returns empty array")
    func filterNoMatches() {
        let vm = RecipeListViewModel()
        vm.searchText = "zzznomatch"
        let result = vm.filteredRecipes(from: Recipe.samples)
        #expect(result.isEmpty)
    }

    // MARK: - Detail ViewModel Tests

    @Test("Detail ViewModel canSave is false when title is empty")
    func canSaveFalseWhenTitleEmpty() {
        let vm = RecipeDetailViewModel()
        vm.draftTitle = "   " // whitespace only
        #expect(vm.canSave == false)
    }

    @Test("Detail ViewModel canSave is true when title has content")
    func canSaveTrueWhenTitleFilled() {
        let vm = RecipeDetailViewModel()
        vm.draftTitle = "My Recipe"
        #expect(vm.canSave == true)
    }

    @Test("beginEditing copies recipe values into drafts")
    func beginEditingCopiesDrafts() {
        let vm = RecipeDetailViewModel()
        let recipe = Recipe.samples[0]
        vm.beginEditing(recipe: recipe)
        #expect(vm.draftTitle == recipe.title)
        #expect(vm.draftCategory == recipe.category)
        #expect(vm.isEditing == true)
    }

    @Test("cancelEditing sets isEditing to false")
    func cancelEditingResetsFlag() {
        let vm = RecipeDetailViewModel()
        vm.isEditing = true
        vm.cancelEditing()
        #expect(vm.isEditing == false)
    }
}
