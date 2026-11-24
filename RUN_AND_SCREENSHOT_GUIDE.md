# Run and capture HealthTrack screens

## Run in Chrome

1. Open the `sdg3_health_app` folder in Visual Studio Code or Android Studio.
2. Open a terminal in the project folder.
3. Run `flutter pub get`.
4. Run `flutter analyze` and resolve any reported errors.
5. Run `flutter test`.
6. Run `flutter run -d chrome`.

## Navigate to the screens

1. Select **Next** on each of the three onboarding pages.
2. On Login, enter a valid-looking email address (for example `student@example.com`) and any non-empty password. The form demonstrates front-end validation only; it does not authenticate an account.
3. The Dashboard opens after the Login form validates.
4. Select **Activities** in the bottom navigation.

## Capture these implementation screenshots

Use the running Flutter Web app, not a design image. Keep the browser window at a consistent size and make sure the full app content is readable.

- **Activity List:** show the heading, Add Activity button, sample records and selected Activities navigation item.
- **Add Activity:** select Add Activity and show the blank form.
- **Edit Activity:** return to the list and select the edit icon on a record so the fields are pre-filled.
- **Activity Form Validation:** open Add Activity and press Save Activity with the required fields empty so the validation messages appear.
- **Dashboard:** select Home and show the daily summary cards.

Save the images as PNG files. Add the four activity images and the Dashboard image to the corresponding report sections. Do not describe a screen as runtime-tested until you have run it and checked the interaction yourself.

## Sample interaction checks

- Add a new activity with a name, category, positive duration and date. Confirm it appears at the top of the Activity List.
- Edit an existing activity. Confirm the same record changes and no duplicate is created.
- Return to Home. Confirm today's activity count, minutes and estimated calories reflect records dated today.
- Try an empty name and a zero-minute duration. Confirm validation blocks saving.
- Try a narrow browser window or mobile emulator. Confirm the form scrolls and the summary cards stack vertically.
