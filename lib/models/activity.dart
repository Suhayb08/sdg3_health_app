class Activity {
  const Activity({
    required this.id,
    required this.name,
    required this.category,
    required this.durationMinutes,
    required this.date,
    required this.estimatedCalories,
    this.notes = '',
  });

  final int id;
  final String name;
  final String category;
  final int durationMinutes;
  final DateTime date;
  final int estimatedCalories;
  final String notes;

  Activity copyWith({
    String? name,
    String? category,
    int? durationMinutes,
    DateTime? date,
    int? estimatedCalories,
    String? notes,
  }) {
    return Activity(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      date: date ?? this.date,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      notes: notes ?? this.notes,
    );
  }
}

String formatActivityDate(DateTime date) {
  const months = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String formatLongDate(DateTime date) {
  const weekdays = <String>[
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];
  const months = <String>[
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
}

bool isSameCalendarDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
