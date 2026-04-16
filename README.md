# Loqmtk Food Delivery App

Flutter application for a food delivery UI concept based on a Figma community design.

## UI Reference (Figma)

The app UI is based on this design:

- [Food App Design UI Template (Figma)](https://www.figma.com/design/n5YK7HwvJYyqAS6DIJf6kO/Food-App-Design-UI-Template--Community-?node-id=0-1&t=98547qoCwzBSFr0w-1)

## Current Implementation

The project currently focuses on the authentication flow UI:

- Splash screen
- Sign up screen (currently set as app home)
- Login screen
- Reusable auth components (button, text, text field)
- Basic form validation flow with feedback via `SnackBar`

## Tech Stack

- Flutter
- Dart SDK `^3.11.4`
- Packages:
  - `flutter_svg`
  - `gap`

## Project Structure

```text
lib/
  core/
    constants/
      app_colors.dart
    utils/
      validators.dart
  features/
    auth/
      views/
        login_view.dart
        signup_view.dart
      widgets/
        custom_auth_button.dart
  shared/
    custom_text.dart
    custom_textform_field.dart
  main.dart
  splash.dart
```

## Getting Started

### 1) Prerequisites

- Flutter SDK installed
- Dart SDK (comes with Flutter)
- Android Studio / VS Code + emulator or physical device

### 2) Install dependencies

```bash
flutter pub get
```

### 3) Run the app

```bash
flutter run
```

## Assets

The project includes:

- Splash images
- Banner and details images folders
- Icons and logo assets
- Custom `Gagalin` font

Declared in `pubspec.yaml`.

## Notes

- App entry point is in `lib/main.dart`.
- Current home screen is `SignUpView`.
- This repository is UI-focused and can be extended with backend integration and state management in the next phase.
