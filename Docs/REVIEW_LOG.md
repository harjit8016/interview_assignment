# Code Review Log

AI-assisted code review conducted using Claude. Prompts and responses documented below.

---

## Review 1 — Recipe Model Design

**Prompt sent to AI:**
> "Review this Swift @Model class for any design issues, SwiftData best practices violations, or potential bugs."
> [pasted Recipe.swift]

**AI Feedback summary:**
- Suggested making `ingredientsRaw` and `stepsRaw` computed getters instead — I rejected this because SwiftData requires stored properties for persistence
- Flagged that `fatalError` in ModelContainer init is acceptable here but noted we should handle gracefully in production — accepted as a known trade-off and noted in ARCHITECTURE.md
- Noted `createdAt` is set at init time which is correct — confirmed

**My response / actions taken:**
- Added the `// Fatal: if the container fails...` comment to make the decision explicit
- No structural changes required

---

## Review 2 — Filter Logic in ViewModel

**Prompt sent to AI:**
> "Review the filteredRecipes function. Are there any edge cases or performance issues?"
> [pasted RecipeListViewModel.swift]

**AI Feedback summary:**
- Noted that `localizedCaseInsensitiveContains` is O(n) per recipe — fine for small datasets, but would need indexing at scale — accepted as appropriate for scope
- Suggested adding a combined search+category filter test — I added `filterByCategory` and `filterNoMatches` tests as a result
- Suggested using `Predicate` macro for server-side filtering instead of in-memory — I considered this but rejected it because the recipe list will never exceed a few hundred items; in-memory filtering keeps ViewModels testable without a ModelContext

**My response / actions taken:**
- Added two extra test cases to PantryTests.swift

---

## Review 3 — Edit Mode Safety

**Prompt sent to AI:**
> "Is there any risk of data loss or unintended mutation in the RecipeDetailViewModel edit flow?"

**AI Feedback summary:**
- Correctly identified that drafts are stored separately from the model, so Cancel truly discards all changes — confirmed correct
- Noted that `saveEdits(to:)` mutates the model directly which triggers SwiftData's change tracking — confirmed this is intentional and correct
- Suggested adding a `hasUnsavedChanges` computed property to warn before navigation — good idea, deferred to future work

**My response / actions taken:**
- Added comment in RecipeDetailViewModel explaining the draft isolation pattern


