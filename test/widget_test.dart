import 'package:flutter_test/flutter_test.dart';
import 'package:sdg3_health_app/main.dart';

void main() {
  testWidgets('HealthTrack opens on the first onboarding screen', (tester) async {
    await tester.pumpWidget(const HealthApp());

    expect(find.text('Welcome to HealthTrack'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
