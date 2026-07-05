# Lab 11: Testing & Debugging

## Objective
Implement comprehensive Testing (Unit Tests, Widget Tests) and perform debugging on a Flutter application. Ensure code reliability and correctness.

## Implementation Details
- Created a robust `TodoListManager` handling core business logic.
- Implemented `TodoListScreen` with interactive state management.
- Added comprehensive unit tests for `TodoListManager` validating edge cases and core features.
- Added widget tests for `TodoListScreen` simulating user interactions (adding, toggling, removing items) and verifying UI updates.

## Observations
- Using precise `Key` assignments allowed reliable Widget testing.
- Unit tests run extremely fast and catch basic logical flaws immediately.
- Widget tests effectively capture integration issues between State and UI elements.

## Problems Encountered
- Initial implementation could have had issues with updating the UI after state mutation.
- Assuring that the completed task counter strictly tracks the toggled check boxes required careful event handling.

## Solutions
- Used `StatefulWidget`'s `setState()` carefully synchronized with `TodoListManager` mutations.
- Added SnackBar error handling to give immediate UI feedback on bad inputs, effectively covered by a Widget test.

## Conclusion
Lab 11 effectively demonstrated the Flutter AAA (Arrange, Act, Assert) testing pattern, ensuring the application handles both normal and exceptional flows gracefully.
