# Smile Reward App

A Flutter application for managing reward points and redeeming rewards.

## Technical Implementation

- Flutter framework
- Material Design 3
- State management using StatefulWidget
- Navigation between pages
- Form validation
- Image loading with error handling

## Versions Used

### Framework & SDK

- **Flutter**: 3.19.6 (stable channel)
- **Dart**: 3.3.4
- **Dart SDK**: >=3.3.4 <4.0.0

### Dependencies

- **flutter**: sdk (Flutter framework core)
- **cupertino_icons**: ^1.0.6 (iOS-style icons)

### Platform Requirements

- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Minimum Flutter**: 3.0.0 or higher

## How to Build and Run

### Prerequisites

1. **Flutter SDK**: Install Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install)

   - Minimum Flutter version: 3.0.0 or higher
   - Ensure Flutter is added to your system PATH

2. **Development Environment**: Choose one of the following:

   - **Visual Studio Code** with Flutter and Dart extensions
   - **Android Studio** with Flutter and Dart plugins

3. **Platform Setup**:
   - **For Android**: Android SDK (API level 21 or higher)

### Installation Steps

1. **Clone or Download the Project**

   ```bash
   git clone https://github.com/Nitidboss/Smile-Reward-App.git
   cd smile_reward_app
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Verify Flutter Installation**
   ```bash
   flutter doctor
   ```
   Fix any issues reported by flutter doctor before proceeding.

### Running Options

#### Option 1: Development Mode (Requires Flutter)

**Using Command Line:**

```bash
# List available devices
flutter devices

# Run on connected Android device/emulator
flutter run
```

**Using IDE:**

- **Visual Studio Code**: Press `F5` or use `Run > Start Debugging`
- **Android Studio**: Click the green play button

#### Option 2: APK Installation (For Testing/Distribution)

**Build APK:**

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

**Install APK:**

- **Method 1 (ADB)**: `adb install build/app/outputs/flutter-apk/app-release.apk`
- **Method 2 (Manual)**: Copy APK to device, enable "Install unknown apps", tap to install
- **Method 3 (Share)**: Upload to cloud/email, download and install on target device

## APK Information

### Ready-to-Install APK

- **Location**: `build/app/outputs/flutter-apk/app-release.apk` or `app-release.apk` in root project
- **File Size**: ~19.5MB (20,449,006 bytes)
- **Requirements**: Android 5.0+ (API level 21+)
- **Installation**: No Flutter required on target device

## App Flow

1. **Login** → Enter credentials → **Home Page**
2. **Home Page** → Browse rewards → Click reward → **Detail Page**
3. **Home Page** → Click heart icon → Save to **Wishlist**
4. **Home Page** → Bottom nav → **Wishlist Page**
5. **Detail Page** → Click Redeem → Confirmation Dialog → Points deducted
6. **Any Page** → Sign Out → **Login Page**
