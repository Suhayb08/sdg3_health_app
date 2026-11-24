# HealthTrack – Practical 1 Flutter Prototype

HealthTrack is a Flutter front-end prototype for recording everyday physical activities. It uses Material widgets and an in-memory Dart list; persistent database storage is outside the scope of Practical 1.

## Included screens

- Three onboarding pages
- Login and registration with client-side validation
- Dashboard with daily activity totals
- Activity List built with `ListView.builder`
- Add Activity and Edit Activity forms
- Profile placeholder screen for the third navigation destination

## Run the application

1. Install Flutter and ensure `flutter` is available in your terminal.
2. Open this project folder (`sdg3_health_app`).
3. Run `flutter pub get`.
4. Run `flutter run -d chrome` to launch the Flutter Web version, or use an Android emulator/device.

## Test the in-memory activity logic

Run `flutter test` from the project folder. The tests cover the sample data, adding records, updating an existing record without duplication, and filtering by calendar date.

## Notes

- Login and registration demonstrate form validation only. They do not authenticate or save real accounts.
- Activity records are held in memory and reset when the application restarts.
- Calories are illustrative estimates for this prototype, not measured health data.
- The sample records match the dates and values used in the Practical 1 report.
