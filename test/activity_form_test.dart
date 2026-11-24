import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sdg3_health_app/data/activity_store.dart';
import 'package:sdg3_health_app/models/activity.dart';
import 'package:sdg3_health_app/screens/activity_form_screen.dart';

Widget _testHost(ActivityStore store, {Activity? activity}) {
  return MaterialApp(
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push<bool>(
                context,
                MaterialPageRoute<bool>(
                  builder: (_) => ActivityFormScreen(store: store, activity: activity),
                ),
              );
            },
            child: const Text('Open form'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('Activity form', () {
    late ActivityStore store;

    setUp(() => store = ActivityStore());
    tearDown(() => store.dispose());

    testWidgets('shows validation messages for missing required fields', (tester) async {
      await tester.pumpWidget(_testHost(store));
      await tester.tap(find.text('Open form'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save Activity'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter an activity name'), findsOneWidget);
      expect(find.text('Please enter duration'), findsOneWidget);
    });

    testWidgets('adds a valid activity to the temporary list', (tester) async {
      await tester.pumpWidget(_testHost(store));
      await tester.tap(find.text('Open form'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Swimming');
      await tester.enterText(find.byType(TextFormField).at(1), '30');
      await tester.tap(find.text('Save Activity'));
      await tester.pumpAndSettle();

      expect(store.activities, hasLength(6));
      expect(store.activities.first.name, 'Swimming');
      expect(store.activities.first.durationMinutes, 30);
    });

    testWidgets('editing changes the existing record instead of adding a duplicate', (tester) async {
      final original = store.activities.first;
      await tester.pumpWidget(_testHost(store, activity: original));
      await tester.tap(find.text('Open form'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Morning Walk Updated');
      await tester.enterText(find.byType(TextFormField).at(1), '45');
      await tester.tap(find.text('Update Activity'));
      await tester.pumpAndSettle();

      expect(store.activities, hasLength(5));
      expect(store.activities.where((item) => item.id == original.id), hasLength(1));
      expect(store.activities.first.name, 'Morning Walk Updated');
      expect(store.activities.first.durationMinutes, 45);
    });
  });
}
