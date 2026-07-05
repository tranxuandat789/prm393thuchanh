import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_tranxuandat/lab11/lab11.dart';

void main() {
  group('Lab 11 - Unit Tests for TodoListManager', () {
    late TodoListManager manager;

    setUp(() {
      manager = TodoListManager();
    });

    test('Initial state should be empty', () {
      expect(manager.items.isEmpty, true);
      expect(manager.completedCount, 0);
    });

    test('Adding a valid item increases the list size', () {
      manager.addItem('Task 1');
      expect(manager.items.length, 1);
      expect(manager.items.first.title, 'Task 1');
      expect(manager.items.first.isDone, false);
    });

    test('Adding an empty item throws ArgumentError', () {
      expect(() => manager.addItem(''), throwsArgumentError);
      expect(() => manager.addItem('   '), throwsArgumentError);
    });

    test('Toggling an item changes its isDone status', () {
      manager.addItem('Task 1');
      final id = manager.items.first.id;

      manager.toggleItem(id);
      expect(manager.items.first.isDone, true);
      expect(manager.completedCount, 1);

      manager.toggleItem(id);
      expect(manager.items.first.isDone, false);
      expect(manager.completedCount, 0);
    });

    test('Removing an item deletes it from the list', () {
      manager.addItem('Task 1');
      manager.addItem('Task 2');
      final id1 = manager.items.first.id;

      manager.removeItem(id1);
      expect(manager.items.length, 1);
      expect(manager.items.first.title, 'Task 2');
    });
  });

  group('Lab 11 - Widget Tests for TodoListScreen', () {
    testWidgets('Renders empty state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const Lab11App());

      expect(find.text('Lab 11 - Testing & Debugging'), findsOneWidget);
      expect(find.byKey(const Key('empty_text')), findsOneWidget);
      expect(find.byKey(const Key('todo_input')), findsOneWidget);
      expect(find.byKey(const Key('add_button')), findsOneWidget);
      expect(find.text('Completed: 0/0'), findsOneWidget);
    });

    testWidgets('Adding a new task updates UI', (WidgetTester tester) async {
      await tester.pumpWidget(const Lab11App());

      // Enter text
      await tester.enterText(
          find.byKey(const Key('todo_input')), 'New Task UI');
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pump();

      expect(find.byKey(const Key('empty_text')), findsNothing);
      expect(find.text('New Task UI'), findsOneWidget);
      expect(find.text('Completed: 0/1'), findsOneWidget);
    });

    testWidgets('Toggling a task updates completed count',
        (WidgetTester tester) async {
      await tester.pumpWidget(const Lab11App());

      // Add task
      await tester.enterText(
          find.byKey(const Key('todo_input')), 'Task to toggle');
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pump();

      // Find checkbox and tap it
      final checkboxFinder = find.byType(Checkbox).first;
      await tester.tap(checkboxFinder);
      await tester.pump();

      expect(find.text('Completed: 1/1'), findsOneWidget);

      // Tap again
      await tester.tap(checkboxFinder);
      await tester.pump();

      expect(find.text('Completed: 0/1'), findsOneWidget);
    });

    testWidgets('Deleting a task removes it from UI',
        (WidgetTester tester) async {
      await tester.pumpWidget(const Lab11App());

      // Add task
      await tester.enterText(
          find.byKey(const Key('todo_input')), 'Task to delete');
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pump();

      expect(find.text('Task to delete'), findsOneWidget);

      // Find delete button and tap
      final deleteButtonFinder = find.byType(IconButton).first;
      await tester.tap(deleteButtonFinder);
      await tester.pump();

      expect(find.text('Task to delete'), findsNothing);
      expect(find.byKey(const Key('empty_text')), findsOneWidget);
      expect(find.text('Completed: 0/0'), findsOneWidget);
    });

    testWidgets('Adding empty task shows SnackBar error',
        (WidgetTester tester) async {
      await tester.pumpWidget(const Lab11App());

      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pump(); // wait for tap to be registered
      await tester.pump(
          const Duration(milliseconds: 100)); // wait for snackbar animation

      expect(find.text('Invalid argument(s): Title cannot be empty'),
          findsOneWidget);
    });
  });
}
