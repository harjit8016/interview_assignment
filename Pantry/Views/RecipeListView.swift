//
//  RecipeListView.swift
//  Pantry
//
//  Created by Harjit Singh on 2026-04-23.
//

import SwiftUI
import SwiftData

/// The main screen — shows all saved recipes in a searchable, filterable list.
struct RecipeListView: View {

    // MARK: - Environment & Data

    @Environment(\.modelContext) private var modelContext

    /// @Query fetches all Recipe objects from SwiftData, sorted newest-first
    @Query(sort: \Recipe.createdAt, order: .reverse)
    private var recipes: [Recipe]

    // MARK: - ViewModel

    @State private var viewModel = RecipeListViewModel()

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Compute filtered results from the full recipe list
                let filtered = viewModel.filteredRecipes(from: recipes)

                // The top filter bar is now static and always visible
                categoryFilterSection

                Group {
                    if recipes.isEmpty {
                        // First launch — no recipes yet
                        EmptyStateView(
                            icon: "🍳",
                            title: "Your pantry is empty",
                            message: "Add your first recipe to get started"
                        )
                    } else if filtered.isEmpty {
                        // Has recipes, but search/filter returned nothing
                        EmptyStateView(
                            icon: "🔍",
                            title: "No results",
                            message: "Try a different search or category"
                        )
                    } else {
                        recipeList(filtered)
                    }
                }
            }
            .navigationTitle("Pantry")
            .searchable(text: $viewModel.searchText, prompt: "Search recipes…")
            .toolbar { toolbarContent }
            .sheet(isPresented: $viewModel.isShowingAddSheet) {
                AddRecipeView()
            }
        }
    }

    // MARK: - Subviews

    /// Scrollable list of recipe cards with category filter chips at the top
    @ViewBuilder
    private func recipeList(_ filtered: [Recipe]) -> some View {
        List {
            // Recipe cards
            ForEach(filtered) { recipe in
                NavigationLink(value: recipe) {
                    RecipeCardView(recipe: recipe)
                }
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .listRowSeparator(.hidden)
            }
            .onDelete { offsets in
                viewModel.deleteRecipes(at: offsets, from: filtered, context: modelContext)
            }
        }
        .listStyle(.plain)
        // NavigationStack destination — typed navigation for type safety
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeDetailView(recipe: recipe)
        }
    }

    /// Horizontally scrolling category filter pills
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(label: "All", isSelected: viewModel.selectedCategory == nil) {
                    viewModel.selectedCategory = nil
                }
                ForEach(Recipe.categories, id: \.self) { category in
                    FilterChip(
                        label: category,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        // Toggle: tapping the active filter clears it
                        viewModel.selectedCategory =
                            viewModel.selectedCategory == category ? nil : category
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.isShowingAddSheet = true
            } label: {
                Label("Add Recipe", systemImage: "plus")
            }
        }
    }
}

// MARK: - Filter Chip Component

/// A small pill-shaped filter button used in the category row
private struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    isSelected
                        ? Color.accentColor
                        : Color(.systemGray6)
                )
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Preview


#Preview {
    let config: ModelConfiguration = .init(isStoredInMemoryOnly: true)
    let schema = Schema([Recipe.self])
    let container = try! ModelContainer(for: schema, configurations: [config])

    // Seed some sample data into the in-memory container
    Recipe.samples.forEach { sample in
        container.mainContext.insert(sample)
    }

    return RecipeListView()
        .modelContainer(container)
}
