# Pantry Project Skills & Rules

This document provides essential context and rules for AI assistants to ensure consistency, save tokens, and prevent hallucinations when working on the Pantry codebase.

## Technical Stack
- **Language**: Swift 5.10+
- **Framework**: SwiftUI
- **Persistence**: SwiftData (iOS 17+)
- **Architecture**: MVVM with @Observable (Avoid ObservableObject/Combine)
- **Navigation**: NavigationStack with typed values (`NavigationLink(value:)`)

## Core Commands
- **Build**: `xcodebuild -project Pantry.xcodeproj -scheme Pantry`
- **Test**: `xcodebuild test -project Pantry.xcodeproj -scheme Pantry -destination 'platform=iOS Simulator,name=iPhone 15'`
- **Lint**: Use Xcode's built-in formatting (Cmd+A, Ctrl+I)

## Project Structure
- `Pantry/Models/`: SwiftData @Model classes.
- `Pantry/ViewModels/`: @Observable classes for state management.
- `Pantry/Views/`: SwiftUI views.
- `Pantry/Views/Components/`: Reusable UI elements (cards, chips, etc).
- `Pantry/Docs/`: Project documentation (AI_LOG.md, ARCHITECTURE.md, etc).

## Critical Coding Rules

### 1. SwiftData Models
- Use the `@Model` macro.
- Prefer stored properties for simple types.
- For arrays of value types (like ingredients), store as a single newline-separated `String` (e.g., `ingredientsRaw`) and use computed properties to parse into arrays. This avoids complex relationship management for simple data.
- Always provide default values for new properties to ensure smooth SwiftData migrations.

### 2. Navigation
- Use `.navigationDestination(for: Recipe.self)` on the root `NavigationStack`.
- Avoid the deprecated closure-based `NavigationLink` within `List` to prevent performance issues.

### 3. Layout & UI
- **Pinned Headers**: Do NOT nest a horizontal `ScrollView` inside a `List` row for category filters. Instead, place the filter bar in a `VStack` above the `List` to keep it static and performant.
- **Empty States**: Always handle both `data.isEmpty` (no data) and `filteredResults.isEmpty` (search/filter return nothing) with distinct `EmptyStateView` messages.

### 4. State Management
- Use the "Draft Pattern" for editing: copy model properties to `@State` or a local ViewModel on edit start. Only write back to the SwiftData `@Model` on explicit "Save". This prevents partial changes from being persisted if the user cancels.

### 5. Testing
- Use the **Swift Testing** framework (`import Testing`).
- Always use an in-memory `ModelContainer` for tests to ensure they are isolated and fast.
- Verify `cookTime` formatting and string parsing helpers as they are core logic.

## Known Gotchas
- `.foregroundStyle(.clear)` on a `Text` element inside a `foregroundStyle` context can cause type errors; use `.foregroundColor(.clear)` as a fallback or ensure `ShapeStyle` types match.
- SwiftData autosaves on the next run loop tick; explicit `try context.save()` is rarely needed but can be used for critical operations.
