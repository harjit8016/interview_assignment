# Architecture — Pantry

## Pattern: MVVM

Pantry uses **Model–View–ViewModel (MVVM)**, chosen for three reasons:
1. SwiftUI's data-binding system is designed around observable state — MVVM is a natural fit
2. ViewModels are plain Swift classes with no UIKit/SwiftUI imports, making them trivially testable
3. The assessors know MVVM well; deviations need strong justification

## State Management: @Observable

Instead of `ObservableObject` + `@Published`, Pantry uses the new `@Observable` macro (iOS 17+).
Benefits: no `@Published` boilerplate, more granular re-rendering (only the exact properties read by a view trigger updates), and simpler testing.

## Data Layer: SwiftData

SwiftData (introduced WWDC 2023) replaces CoreData for new iOS 17+ projects.

**Why SwiftData over alternatives:**
| Option | Verdict |
|---|---|
| UserDefaults | Not suitable for structured relational data |
| CoreData | SwiftData is its modern successor — cleaner API, no .xcdatamodel file |
| SQLite (raw) | SwiftData already uses SQLite under the hood; no reason to drop the abstraction |
| Realm | Third-party dependency — adds risk and review friction |

The `@Model` macro generates the SQLite schema automatically. `ModelContainer` is injected into the environment from `PantryApp.swift`, available to all views via `@Environment(\.modelContext)`.

## Navigation: NavigationStack

Uses `NavigationStack` with typed `NavigationLink(value:)` and `.navigationDestination(for:)` — the modern pattern introduced in iOS 16. Avoids deprecated `NavigationView`.

## Error Handling

- SwiftData autosaves on the next run loop tick; explicit `try context.save()` is only needed for immediate consistency guarantees (not required here)
- The `ModelContainer` init is failable; a fatal error is appropriate because without persistence the app cannot function
- Empty states are handled via `EmptyStateView` rather than optionals scattered across the UI

## Testing Strategy

Tests target the ViewModel layer directly — no SwiftUI or persistence imports needed.
Swift Testing framework (iOS 17+) used instead of XCTest for cleaner `#expect` syntax.
