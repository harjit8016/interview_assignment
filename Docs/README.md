# 🥘 Pantry AI
### Smart Recipe Management & AI Extraction

A modern iOS application built with **SwiftUI**, **SwiftData**, and **Gemini + XCode with ChatGPT**. Pantry transforms messy cooking notes into structured, beautiful recipe cards using AI.

---

## 📱 App Interface

<table style="width: 100%; border-collapse: collapse; border: none;">
  <tr>
    <td align="center" style="border: none;">
      <img src="https://raw.githubusercontent.com/harjit8016/interview_assignment/main/AppImages/RecipeList.png" width="100%" alt="Add Recipe"/><br/>
      <sub><b>Add Recipe</b></sub>
    </td>
    <td align="center" style="border: none;">
      <img src="https://raw.githubusercontent.com/harjit8016/interview_assignment/main/AppImages/AddRecipeForm.png" width="100%" alt="Recipe List"/><br/>
      <sub><b>Recipe Feed</b></sub>
    </td>
    <td align="center" style="border: none;">
      <img src="https://raw.githubusercontent.com/harjit8016/interview_assignment/main/AppImages/DetailRecipe.png" width="100%" alt="Ingredients"/><br/>
      <sub><b>Details</b></sub>
    </td>
    <td align="center" style="border: none;">
      <img src="https://raw.githubusercontent.com/harjit8016/interview_assignment/main/AppImages/EditRecipe.png" width="100%" alt="Settings"/><br/>
      <sub><b>Settings</b></sub>
    </td>
  </tr>
</table>

<br/>

<p align="center">
  <img src="https://raw.githubusercontent.com/harjit8016/interview_assignment/main/AppImages/AppFlowDiagram.png" width="100%" alt="Main App Banner" />
  <br/>
  <i>Pantry Workflow: From Raw Text to Digital Masterpiece</i>
</p>
---

## 🧪 Sample Testing Data
This data is used to verify layout responsiveness and category filtering within the app.

| Recipe Name | Category | Cook Time | Key Ingredient | Emoji |
| :--- | :--- | :--- | :--- | :---: |
| **Spaghetti Carbonara** | Dinner | 25 mins | Pancetta | 🍝 |
| **Avocado Toast** | Breakfast | 10 mins | Avocado | 🥑 |
| **Chocolate Lava Cake** | Dessert | 15 mins | Dark Chocolate | 🍫 |

---

## 📝 Recipe Details (Plain English)

### 1. Spaghetti Carbonara
**Summary:** Creamy Roman pasta with egg and pancetta.
* **Ingredients:** 200g spaghetti, 100g pancetta, 2 large eggs, 50g Pecorino Romano, Black pepper.
* **Steps:** 1. Boil pasta in salted water until al dente.
  2. Fry pancetta until crisp.
  3. Whisk eggs with grated cheese.
  4. Drain pasta, reserving 1 cup water.
  5. Combine off-heat with egg mixture.
  6. Add pasta water to loosen.
  7. Top with pancetta and black pepper.

### 2. Avocado Toast
**Summary:** Simple and nutritious breakfast classic.
* **Ingredients:** 2 slices sourdough, 1 ripe avocado, Lemon juice, Salt and chili flakes.
* **Steps:** 1. Toast the bread until golden.
  2. Mash avocado with lemon juice and salt.
  3. Spread onto toast.
  4. Finish with chili flakes.

### 3. Chocolate Lava Cake
**Summary:** Warm, gooey chocolate dessert in 15 minutes.
* **Ingredients:** 200g dark chocolate, 100g butter, 4 eggs, 100g sugar, 60g flour.
* **Steps:** 1. Preheat oven to 200°C.
  2. Melt chocolate and butter together.
  3. Whisk eggs and sugar until pale.
  4. Fold in chocolate mixture then flour.
  5. Pour into greased ramekins.
  6. Bake 12 minutes — centre should be liquid.

---

## 🛠 Features
- **Auto-Sizing Text Editor:** Custom multi-line input that expands as you type.
- **AI Formatting:** Gemini integration to clean up raw text into structured recipes.
- **SwiftData Storage:** High-performance local persistence for iOS.

---

<p align="center">
  Developed by <b>Harjit Singh</b> 🇮🇳
</p>

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
