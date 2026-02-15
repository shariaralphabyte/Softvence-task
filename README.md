# Softvence App

A professional Flutter application featuring a premium UI, seamless onboarding, location services, and a robust date/time-based alarm system.

## 🎨 Premium UI Redesign
The app has been completely redesigned with a high-end look:
- **Custom Gradient Background**: Sleek `#082257` to `#0B0024` transition.
- **Glassmorphic UI**: Transparent cards and inputs for a modern feel.
- **Interactive Onboarding**: A 3-page introduction with high-quality imagery and smooth indicators.
- **Smart Experience**: Context-aware location requests and professional system dialogs.

## 🚀 Key Features

- **Optimized Startup**: Custom Splash Screen and non-blocking background initialization for instant app response.
- **Onboarding Flow**: 
  - Educational screens with "Skip" and "Next/Get Started" functionality.
- **Smart Location Integration**:
  - Uses the native **GMS Location Request Dialog** (Google Maps style) to enable GPS effortlessly.
  - Graceful permission handling and error feedback.
- **Alarms & Notifications**:
  - **Date & Time Selection**: Choose a specific date and time for your alarm.
  - **Accurate Scheduling**: Leverages timezone processing for universal reliability.
  - **Persistence**: Alarms are saved using **Hive** for fast, reliable local storage.
  - **Rich Notifications**: High-priority alarm notifications with vibration and sound support.

## 🛠 Tech Stack & Tools

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [Riverpod](https://riverpod.dev) (Standard for senior Flutter development)
- **Local Storage**: [Hive](https://docs.hivedb.dev) (High-performance NoSQL database)
- **Notifications**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- **Location**: [location](https://pub.dev/packages/location) (Chosen for professional resolution dialogs)
- **Timezone Support**: [timezone](https://pub.dev/packages/timezone) & [flutter_timezone](https://pub.dev/packages/flutter_timezone)
- **Date Formatting**: [intl](https://pub.dev/packages/intl)

## 🏗 Project Structure

```
lib/
├── common_widgets/    # Atomic reusable UI components (Buttons, etc.)
├── constants/         # App constants, shared colors, and theme data
├── features/          # Clean Architecture: Feature-first structure
│   ├── alarm/         # Alarm screens, services, and models
│   ├── location/      # Location services and screens
│   └── onboarding/    # User onboarding journey
├── helpers/           # Initialization and utility logic (Startup, LocationHelper)
├── networks/          # Base API Client structure
└── main.dart          # App entry point with ProviderScope
```

## ⚙️ Setup & Installation

1.  **Prerequisites**: 
    - Install [Flutter SDK](https://docs.flutter.dev/get-started/install).
    - Ensure an Android Emulator or iOS Simulator is running.

2.  **Clone & Navigate**:
    ```bash
    cd Softvence
    ```

3.  **Install Packages**:
    ```bash
    flutter pub get
    ```

4.  **Run Application**:
    ```bash
    flutter run
    ```

## 🔐 Configuration & Permissions

### Android
Managed in `AndroidManifest.xml`:
- `INTERNET`: For network tasks.
- `ACCESS_FINE_LOCATION`: For high-accuracy GPS.
- `POST_NOTIFICATIONS`: For Android 13+ alerts.
- `SCHEDULE_EXACT_ALARM`: For precise alarm timing.

### iOS
Managed in `Info.plist`:
- `NSLocationWhenInUseUsageDescription`: Required for location access.

---
Built with ❤️ by Softvence Team.
