import 'package:flutter/foundation.dart';

import '../models/activity.dart';

/// In-memory data store for Practical 1.
/// The records reset when the application is restarted; database storage is
/// intentionally left for Practical 2.
class ActivityStore extends ChangeNotifier {
  ActivityStore()
      : _activities = <Activity>[
          Activity(
            id: 1,
            name: 'Morning Walk',
            category: 'Walking',
            durationMinutes: 30,
            date: DateTime(2026, 11, 21),
            estimatedCalories: 120,
          ),
          Activity(
            id: 2,
            name: 'Cycling',
            category: 'Cycling',
            durationMinutes: 45,
            date: DateTime(2026, 11, 20),
            estimatedCalories: 280,
          ),
          Activity(
            id: 3,
            name: 'Yoga Session',
            category: 'Yoga',
            durationMinutes: 20,
            date: DateTime(2026, 11, 19),
            estimatedCalories: 90,
          ),
          Activity(
            id: 4,
            name: 'Evening Run',
            category: 'Running',
            durationMinutes: 25,
            date: DateTime(2026, 11, 18),
            estimatedCalories: 210,
          ),
          Activity(
            id: 5,
            name: 'Stretching',
            category: 'Stretching',
            durationMinutes: 15,
            date: DateTime(2026, 11, 17),
            estimatedCalories: 50,
          ),
        ];

  final List<Activity> _activities;
  int _nextId = 6;

  List<Activity> get activities => List<Activity>.unmodifiable(_activities);

  List<Activity> activitiesForDay(DateTime day) {
    return _activities
        .where((activity) => isSameCalendarDay(activity.date, day))
        .toList(growable: false);
  }

  void addActivity({
    required String name,
    required String category,
    required int durationMinutes,
    required DateTime date,
    String notes = '',
  }) {
    _activities.insert(
      0,
      Activity(
        id: _nextId++,
        name: name.trim(),
        category: category,
        durationMinutes: durationMinutes,
        date: DateTime(date.year, date.month, date.day),
        estimatedCalories: estimateCalories(category, durationMinutes),
        notes: notes.trim(),
      ),
    );
    notifyListeners();
  }

  void updateActivity(Activity updatedActivity) {
    final index = _activities.indexWhere(
      (activity) => activity.id == updatedActivity.id,
    );
    if (index == -1) return;

    _activities[index] = updatedActivity.copyWith(
      name: updatedActivity.name.trim(),
      date: DateTime(
        updatedActivity.date.year,
        updatedActivity.date.month,
        updatedActivity.date.day,
      ),
      estimatedCalories: estimateCalories(
        updatedActivity.category,
        updatedActivity.durationMinutes,
      ),
      notes: updatedActivity.notes.trim(),
    );
    notifyListeners();
  }

  void deleteActivity(int id) {
    _activities.removeWhere((activity) => activity.id == id);
    notifyListeners();
  }

  /// Simple illustrative estimate used for the sample prototype only.
  /// It is not a medical or fitness measurement.
  int estimateCalories(String category, int minutes) {
    const caloriesPerMinute = <String, double>{
      'Walking': 4.0,
      'Cycling': 6.22,
      'Yoga': 4.5,
      'Running': 8.4,
      'Cardio': 7.0,
      'Strength': 5.0,
      'Swimming': 7.0,
      'Stretching': 3.3,
      'Other': 4.0,
    };
    final rate = caloriesPerMinute[category] ?? 4.0;
    return (minutes * rate).round();
  }
}
