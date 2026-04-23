//
//  AddRecipeView.swift
//  Pantry
//
//  Created by Harjit Singh on 2026-04-23.
//

import SwiftUI
import SwiftData

/// Sheet for creating a new recipe.
/// Dismissed automatically on save or cancel.
struct AddRecipeView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // MARK: - Form State

    @State private var title       = ""
    @State private var summary     = ""
    @State private var emoji       = "🍽️"
    @State private var category    = "Dinner"
    @State private var cookTime    = 30
    @State private var servings    = 4
    @State private var ingredients = ""
    @State private var steps       = ""

    // MARK: - Validation

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    HStack {
                        Text("Emoji")
                            .foregroundStyle(.secondary)
                        Spacer()
                        TextField("🍽️", text: $emoji)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 50)
                    }

                    TextField("Recipe name", text: $title)
                    //TextField("Short description", text: $summary)
                    AutoSizingTextEditor(text: $summary,placeholder: "Short description")
                }

                Section("Details") {
                    Picker("Category", selection: $category) {
                        ForEach(Recipe.categories, id: \.self) { Text($0) }
                    }

                    Stepper("Cook time: \(cookTime) min", value: $cookTime, in: 1...480, step: 5)
                    Stepper("Servings: \(servings)", value: $servings, in: 1...20)
                }

                Section("Ingredients") {
                    Text("One ingredient per line")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextEditor(text: $ingredients)
                        .frame(minHeight: 100)
                }

                Section("Steps") {
                    Text("One step per line")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextEditor(text: $steps)
                        .frame(minHeight: 120)
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveAndDismiss() }
                        .disabled(!canSave)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Actions

    private func saveAndDismiss() {
        let recipe = Recipe(
            title: title.trimmingCharacters(in: .whitespaces),
            summary: summary,
            cookTimeMinutes: cookTime,
            servings: servings,
            category: category,
            ingredientsRaw: ingredients,
            stepsRaw: steps,
            emoji: emoji.isEmpty ? "🍽️" : emoji
        )
        // Insert into context — SwiftData autosaves
        modelContext.insert(recipe)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    AddRecipeView()
        .modelContainer(for: Recipe.self, inMemory: true)
}
