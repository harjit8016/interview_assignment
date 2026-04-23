//
//  RecipeCardView.swift
//  Pantry
//
//  Created by Harjit Singh on 2026-04-23.
//

import SwiftUI

/// A card cell displayed in the recipe list.
/// Intentionally kept as a pure display component — no business logic.
struct RecipeCardView: View {

    let recipe: Recipe

    var body: some View {
        HStack(spacing: 14) {
            // Emoji thumbnail in a coloured circle
            ZStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 56, height: 56)
                Text(recipe.emoji)
                    .font(.system(size: 30))
            }

            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(1)

                Text(recipe.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                // Metadata pills
                HStack(spacing: 6) {
                    miniPill(icon: "clock", text: recipe.cookTimeFormatted)
                    miniPill(icon: "tag", text: recipe.category)
                }
            }

            Spacer()
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private func miniPill(icon: String, text: String) -> some View {
        Label(text, systemImage: icon)
            .font(.caption2)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    RecipeCardView(recipe: Recipe.samples[0])
        .padding()
}
