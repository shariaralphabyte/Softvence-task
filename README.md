# Softvence App

A Flutter application featuring a seamless onboarding experience, location services integration, and a local alarm system with notifications. Built based on the provided Figma design requirements.

## Features

- **Onboarding Flow**: 
  - Three distinct screens guiding the user through the app's value proposition.
  - "Skip" functionality to bypass onboarding.
  - Smooth page transitions and dot indicators.

- **Location Services**:
  - Requests user permission to access device location.
  - Fetches and displays current latitude and longitude coordinates.
  - Handles permission denial gracefully.

- **Alarms & Notifications**:
  - Schedule local alarms using a native time picker.
  - Persist alarms locally using **Hive** database.
  - Trigger local notifications at the scheduled time using **Flutter Local Notifications**.
  - List view to manage and delete active alarms.

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- **Local Storage**: [hive](https://pub.dev/packages/hive) & [hive_flutter](https://pub.dev/packages/hive_flutter)
- **Notifications**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- **Location**: [geolocator](https://pub.dev/packages/geolocator)
- **Timezone**: [timezone](https://pub.dev/packages/timezone) for accurate scheduling.
- **Permissions**: [permission_handler](https://pub.dev/packages/permission_handler)

## Project Structure

```
lib/
├── common_widgets/    # Reusable UI components
├── constants/         # App constants (strings, colors, etc.)
├── features/          # Feature-based architecture
│   ├── alarm/         # Alarm screens and services
│   ├── location/      # Location screens and services
│   └── onboarding/    # Onboarding screens and widgets
├── helpers/           # Utility functions
├── networks/          # Network layer (if applicable)
└── main.dart          # Entry point
```

## Setup & Installation

1.  **Prerequisites**: Ensure you have Flutter installed and set up for your platform (Android/iOS).

2.  **Clone the repository** (or navigate to the project folder):
    ```bash
    cd Softvence
    ```

3.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

4.  **Run the app**:
    ```bash
    flutter run
    ```

## Permissions

### Android
Permissions are handled in `AndroidManifest.xml`. The app requires:
- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`
- `POST_NOTIFICATIONS`
- `SCHEDULE_EXACT_ALARM`

### iOS
Permissions are handled in `Info.plist`. The app requires:
- `NSLocationWhenInUseUsageDescription`

## Notes
- The app uses **Hive** for lightweight local storage of alarm times.
- Notifications are scheduled to repeat daily at the selected time (code logic in `NotificationService`).
