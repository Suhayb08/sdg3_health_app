import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sdg3_health_app/data/activity_store.dart';
import 'package:sdg3_health_app/home_shell.dart';

void main() {
  testWidgets('Activity List displays sample records in a scrolling list', (tester) async {
    final store = ActivityStore();
    addTearDown(store.dispose);

    await tester.pumpWidget(
      MaterialApp(home: HomeShell(store: store)),
    );

    await tester.tap(find.byIcon(Icons.directions_run_outlined));
    await tester.pumpAndSettle();

    expect(find.text('My Activities'), findsOneWidget);
    expect(find.text('Morning Walk'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
