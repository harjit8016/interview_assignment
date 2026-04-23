//
//  EmptyStateView.swift
//  Pantry
//
//  Created by Harjit Singh on 2026-04-23.
//

import SwiftUI

/// Displayed when there are no recipes — either on first launch or after a search returns nothing.
struct EmptyStateView: View {

    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Text(icon)
                .font(.system(size: 64))

            Text(title)
                .font(.title3)
                .fontWeight(.semibold)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        icon: "🍳",
        title: "Your pantry is empty",
        message: "Add your first recipe to get started"
    )
}
