import 'package:flutter/material.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'Walking':
      return Icons.directions_walk_rounded;
    case 'Cycling':
      return Icons.directions_bike_rounded;
    case 'Yoga':
      return Icons.self_improvement_rounded;
    case 'Running':
      return Icons.directions_run_rounded;
    case 'Cardio':
    case 'Strength':
      return Icons.fitness_center_rounded;
    case 'Swimming':
      return Icons.pool_rounded;
    case 'Stretching':
      return Icons.accessibility_new_rounded;
    default:
      return Icons.favorite_rounded;
  }
}
