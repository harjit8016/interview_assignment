//
//  RecipeDetailViewModel.swift
//  Pantry
//
//  Created by Harjit Singh on 2026-04-23.
//

import SwiftData
import Observation
import Foundation
/// ViewModel for the recipe detail screen.
/// Manages edit mode state and save/discard logic.
@Observable
final class RecipeDetailViewModel {

    // MARK: - Edit State

    var isEditing: Bool = false

    /// Temporary copies of fields — only written to the model on save
    var draftTitle: String = ""
    var draftSummary: String = ""
    var draftCookTime: Int = 30
    var draftServings: Int = 4
    var draftCategory: String = "Dinner"
    var draftIngredients: String = ""
    var draftSteps: String = ""
    var draftEmoji: String = "🍽️"

    // MARK: - Enter / Exit Edit Mode

    /// Copies the recipe's current values into drafts before editing
    func beginEditing(recipe: Recipe) {
        draftTitle       = recipe.title
        draftSummary     = recipe.summary
        draftCookTime    = recipe.cookTimeMinutes
        draftServings    = recipe.servings
        draftCategory    = recipe.category
        draftIngredients = recipe.ingredientsRaw
        draftSteps       = recipe.stepsRaw
        draftEmoji       = recipe.emoji
        isEditing        = true
    }

    /// Writes draft values back to the model — SwiftData will persist automatically
    func saveEdits(to recipe: Recipe) {
        recipe.title           = draftTitle
        recipe.summary         = draftSummary
        recipe.cookTimeMinutes = draftCookTime
        recipe.servings        = draftServings
        recipe.category        = draftCategory
        recipe.ingredientsRaw  = draftIngredients
        recipe.stepsRaw        = draftSteps
        recipe.emoji           = draftEmoji
        isEditing              = false
    }

    /// Discards changes — drafts are simply abandoned
    func cancelEditing() {
        isEditing = false
    }

    // MARK: - Validation

    var canSave: Bool {
        !draftTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
