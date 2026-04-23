//
//  RecipeDetailView.swift
//  Pantry
//
//  Created by Harjit Singh on 2026-04-23.
//

import SwiftUI
import SwiftData

/// Shows full details of a recipe.
/// Supports inline editing — tapping Edit enters a draft mode;
/// changes are only committed on Save.
struct RecipeDetailView: View {

    // MARK: - Input

    let recipe: Recipe

    // MARK: - ViewModel

    @State private var viewModel = RecipeDetailViewModel()

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                heroSection
                metaRow
                if viewModel.isEditing {
                    editForm
                } else {
                    ingredientsSection
                    stepsSection
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.isEditing ? "Editing" : recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        // Ensure toolbar updates when edit state changes
        .animation(.easeInOut(duration: 0.2), value: viewModel.isEditing)
    }

    // MARK: - Hero

    /// Large emoji + title + summary at the top
    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.emoji)
                .font(.system(size: 72))

            if !viewModel.isEditing {
                Text(recipe.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(recipe.summary)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
    }

    /// Cook time, servings, category badges
    private var metaRow: some View {
        HStack(spacing: 12) {
            MetaBadge(icon: "clock", text: recipe.cookTimeFormatted)
            MetaBadge(icon: "person.2", text: "\(recipe.servings) servings")
            MetaBadge(icon: "tag", text: recipe.category)
            Spacer()
        }
    }

    // MARK: - Ingredients

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Ingredients")

            if recipe.ingredients.isEmpty {
                Text("No ingredients listed")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            } else {
                ForEach(recipe.ingredients, id: \.self) { ingredient in
                    HStack(alignment: .top, spacing: 10) {
                        // Bullet dot
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 6, height: 6)
                            .padding(.top, 7)
                        Text(ingredient)
                            .font(.body)
                    }
                }
            }
        }
    }

    // MARK: - Steps

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Steps")

            if recipe.steps.isEmpty {
                Text("No steps listed")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            } else {
                ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        // Step number circle
                        ZStack {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 26, height: 26)
                            Text("\(index + 1)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                        Text(step)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    // MARK: - Edit Form

    /// Inline edit form shown when isEditing = true
    private var editForm: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Edit Recipe")

            Group {
                LabeledTextField(label: "Title", text: $viewModel.draftTitle)
                LabeledTextField(label: "Summary", text: $viewModel.draftSummary)
                LabeledTextField(label: "Emoji", text: $viewModel.draftEmoji)

                // Category picker
                VStack(alignment: .leading, spacing: 4) {
                    Text("Category").font(.caption).foregroundStyle(.secondary)
                    Picker("Category", selection: $viewModel.draftCategory) {
                        ForEach(Recipe.categories, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.menu)
                }

                // Cook time stepper
                Stepper(
                    "Cook time: \(viewModel.draftCookTime) min",
                    value: $viewModel.draftCookTime,
                    in: 1...480,
                    step: 5
                )

                // Servings stepper
                Stepper(
                    "Servings: \(viewModel.draftServings)",
                    value: $viewModel.draftServings,
                    in: 1...20
                )

                // Ingredients text editor
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ingredients (one per line)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextEditor(text: $viewModel.draftIngredients)
                        .frame(minHeight: 100)
                        .font(.body)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                // Steps text editor
                VStack(alignment: .leading, spacing: 4) {
                    Text("Steps (one per line)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextEditor(text: $viewModel.draftSteps)
                        .frame(minHeight: 120)
                        .font(.body)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if viewModel.isEditing {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    viewModel.cancelEditing()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.saveEdits(to: recipe)
                }
                .disabled(!viewModel.canSave)
                .fontWeight(.semibold)
            }
        } else {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    viewModel.beginEditing(recipe: recipe)
                }
            }
        }
    }
}

// MARK: - Helper Components

private struct MetaBadge: View {
    let icon: String
    let text: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
    }
}

private struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
    }
}

private struct LabeledTextField: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            TextField(label, text: $text)
                .textFieldStyle(.roundedBorder)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe.samples[0])
    }
    .modelContainer(for: Recipe.self, inMemory: true)
}
