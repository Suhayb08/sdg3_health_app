import 'package:flutter_test/flutter_test.dart';
import 'package:sdg3_health_app/data/activity_store.dart';
import 'package:sdg3_health_app/models/activity.dart';

void main() {
  group('ActivityStore', () {
    late ActivityStore store;

    setUp(() {
      store = ActivityStore();
    });

    tearDown(() {
      store.dispose();
    });

    test('starts with the five sample activities from the report', () {
      expect(store.activities, hasLength(5));
      expect(store.activities.first.name, 'Morning Walk');
      expect(store.activities.first.estimatedCalories, 120);
    });

    test('adds a new activity and estimates calories', () {
      store.addActivity(
        name: 'Swimming',
        category: 'Swimming',
        durationMinutes: 30,
        date: DateTime(2026, 11, 21),
      );

      expect(store.activities, hasLength(6));
      expect(store.activities.first.name, 'Swimming');
      expect(store.activities.first.estimatedCalories, 210);
    });

    test('updates the existing record without creating a duplicate', () {
      final original = store.activities.first;
      store.updateActivity(original.copyWith(durationMinutes: 45));

      expect(store.activities, hasLength(5));
      expect(store.activities.where((item) => item.id == original.id), hasLength(1));
      expect(store.activities.first.durationMinutes, 45);
      expect(store.activities.first.estimatedCalories, 180);
    });

    test('filters activities by calendar day', () {
      final results = store.activitiesForDay(DateTime(2026, 11, 21, 18, 30));
      expect(results, hasLength(1));
      expect(results.single.name, 'Morning Walk');
    });

    test('does not change the stored list when an unknown id is updated', () {
      store.updateActivity(
        Activity(
          id: 999,
          name: 'Unknown',
          category: 'Walking',
          durationMinutes: 10,
          date: DateTime(2026, 11, 21),
          estimatedCalories: 40,
        ),
      );
      expect(store.activities, hasLength(5));
    });
  });
}
