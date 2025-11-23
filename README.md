# Theme Box Controller 🎵

A modern Flutter mobile application to control the Theme Box ESP8266 IoT device. Change your room's atmosphere with different themes featuring LEDs, sounds, and ambient effects.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)

## Features ✨

- **Multiple Themes**: Forest, Christmas, and Campfire modes
- **Customizable Controls**: Adjust brightness, volume, and animation speed
- **Real-time Status**: Live connection monitoring and theme status
- **WiFi Control**: Connect to your Theme Box over local network
- **Modern UI**: Beautiful Material Design 3 interface with gradient backgrounds
- **Auto-connect**: Automatically connect to device on app start
- **Connection Testing**: Test device connectivity before activation

## Screenshots

### Home Screen
- Grid view of all available themes
- Current status indicator
- Connection status with pulsing animation
- Bottom navigation

### Theme Detail Screen
- Large theme icon and description
- Interactive sliders for brightness, volume, and speed
- One-tap theme activation
- Success/error feedback

### Settings Screen
- IP address and port configuration
- Connection test button
- Auto-connect preference
- Input validation

## Prerequisites 📋

Before you begin, ensure you have:

1. **Flutter SDK** installed (version 3.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   
2. **Android Studio** or **VS Code** with Flutter extensions

3. **A physical device or emulator** for testing

4. **Theme Box ESP8266 device** on the same WiFi network

## Installation 🚀

### Step 1: Install Flutter

**Windows:**
```powershell
# Download Flutter SDK from flutter.dev
# Extract to C:\src\flutter
# Add to PATH: C:\src\flutter\bin

# Verify installation
flutter doctor
```

**macOS/Linux:**
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

### Step 2: Clone or Navigate to Project

```powershell
cd C:\Users\ahmed\Desktop\koodi2\theme_box_controller
```

### Step 3: Install Dependencies

```powershell
flutter pub get
```

This will install:
- `http` - HTTP networking
- `shared_preferences` - Local storage
- `provider` - State management
- `google_fonts` - Custom fonts

### Step 4: Run the App

**On Android Device/Emulator:**
```powershell
flutter run
```

**Build APK for Android:**
```powershell
flutter build apk --release
```
APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

**Build for iOS (macOS only):**
```powershell
flutter build ios --release
```

## Configuration ⚙️

### First Time Setup

1. **Launch the app**
2. **Go to Settings** (bottom navigation)
3. **Enter your ESP8266 IP address** (default: `192.168.4.1`)
4. **Set port** (default: `80`)
5. **Tap "Test Connection"** to verify
6. **Enable "Auto-connect"** if desired
7. **Save Settings**

### Finding Your ESP8266 IP Address

Your ESP8266 displays its IP address on the OLED screen after connecting to WiFi. Alternatively:

1. Check your router's connected devices
2. Use a network scanner app
3. Look at the Serial Monitor output when ESP8266 boots

## Usage 📱

### Activating a Theme

1. **From Home Screen**: Tap any theme card to open details
2. **Adjust Settings**: Use sliders to set brightness, volume, and speed
3. **Activate**: Tap "Activate Theme" button
4. **Confirmation**: Success message appears and you return to home

### Quick Return to Menu

- Tap the floating "Back to Menu" button on home screen when a theme is active
- Or use the joystick on the physical device

### Monitoring Status

- The status card shows current active theme
- Connection indicator shows device connectivity
- Pull down on home screen to refresh status

## Project Structure 📁

```
theme_box_controller/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   ├── theme_model.dart         # Theme data model
│   │   └── device_config.dart       # Device configuration
│   ├── services/
│   │   └── api_service.dart         # HTTP API communication
│   ├── screens/
│   │   ├── home_screen.dart         # Main dashboard
│   │   ├── theme_detail_screen.dart # Theme controls
│   │   ├── settings_screen.dart     # Device settings
│   │   └── about_screen.dart        # About page
│   ├── widgets/
│   │   ├── theme_card.dart          # Reusable theme card
│   │   └── status_indicator.dart    # Connection status
│   └── theme/
│       └── app_theme.dart           # App-wide theming
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

## API Endpoints 🔌

The app communicates with ESP8266 using these endpoints:

### Get Status
```
GET http://{ip}:{port}/status
Response: {"mode": 0-2, "active": true/false}
```

### Activate Theme
```
GET http://{ip}:{port}/setMode?m={0-2}&brightness={0-100}&volume={0-100}&speed={0-100}
Response: "OK"
```

### Back to Menu
```
GET http://{ip}:{port}/backToMenu
Response: "OK"
```

## Troubleshooting 🔧

### "Connection Failed" Error

1. **Check WiFi**: Ensure phone and ESP8266 are on same network
2. **Verify IP**: Confirm IP address in settings matches ESP8266
3. **Test Connection**: Use "Test Connection" button in settings
4. **Firewall**: Check if firewall is blocking connection
5. **ESP8266 Status**: Verify ESP8266 is powered on and connected

### App Won't Build

```powershell
# Clean build cache
flutter clean

# Get dependencies again
flutter pub get

# Run flutter doctor
flutter doctor -v
```

### Sliders Don't Work

The ESP8266 code needs to be updated to support brightness/volume/speed parameters. See the implementation plan for ESP8266 code modifications.

## Future Enhancements 🚀

- [ ] Add City Mode (4th theme)
- [ ] Theme scheduling (activate at specific times)
- [ ] Custom theme creation
- [ ] Multi-device support
- [ ] Voice control integration
- [ ] Bluetooth connectivity option
- [ ] Theme favorites
- [ ] Usage statistics

## Development 👨‍💻

### Running in Debug Mode

```powershell
flutter run --debug
```

### Hot Reload

Press `r` in terminal while app is running to hot reload changes.

### Viewing Logs

```powershell
flutter logs
```

## Contributing 🤝

This is a personal project for ICT Engineering studies. Suggestions and improvements are welcome!

## License 📄

© 2025 Ahmed. All rights reserved.

This project is created for educational purposes as part of ICT Engineering studies.

## Contact 📧

**Developer**: AH.IS  
**Role**: Engineering Student  
**Project**: Theme Box IoT Controller

---

Made with ❤️ for IoT enthusiasts
