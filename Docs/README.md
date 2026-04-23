# Pantry 🍳

A personal recipe book iOS app built with Swift, SwiftUI, and SwiftData.

## Tech Stack

- **Language:** Swift 5.10
- **UI:** SwiftUI
- **Persistence:** SwiftData (SQLite-backed, iOS 17+)
- **Architecture:** MVVM with `@Observable`
- **Testing:** Swift Testing framework
- **Minimum iOS:** 17.0

## Setup

1. Clone the repository
2. Open `Pantry.xcodeproj` in Xcode 15 or later
3. Select a simulator running iOS 17+
4. Press **⌘R** to build and run — no additional configuration needed

## Features

- Browse recipes in a searchable, category-filtered list
- View full recipe detail: ingredients, steps, cook time, servings
- Add new recipes via a form sheet
- Edit existing recipes inline with draft/discard support
- Swipe-to-delete from the list
- Persists across app launches via SwiftData

## Running Tests

Press **⌘U** or go to **Product → Test**. All tests are in `PantryTests.swift`.

## AI Reflection

Using Claude as a development partner meaningfully accelerated this project. The most valuable phases were architecture design (the AI correctly argued for SwiftData over CoreData and `@Observable` over `ObservableObject`, both of which I verified and agreed with) and test generation (the AI suggested edge cases I hadn't considered, particularly around whitespace-only input validation). The biggest lesson: AI output required careful review — the first draft of the filter logic had an off-by-one error in the sort order, which I caught during code review. I'd estimate AI assistance saved 1–2 hours and improved test coverage by roughly 30%.
