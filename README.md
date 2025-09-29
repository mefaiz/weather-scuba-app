# Scuba Weather App

A Flutter weather application specifically designed for scuba diving locations in Malaysia, featuring real-time weather data from Open-Meteo API.

## Screenshots

<p float="left">
  <img src="lib/screenshot/screenshot1.png" width="250" alt="Initial UI" />
  <img src="lib/screenshot/screenshot2.png" width="250" alt="Location Selection" />
</p>

## Features

- 🌡️ Real-time weather data including:
  - Temperature
  - Feels-like temperature
  - Humidity levels
  - Wind speed
  - Precipitation
- 📍 Location support:
  - Current location detection
- 🏗️ Clean Architecture implementation
- 📱 Material Design 3 UI components
- 🔄 State Management using Riverpod StateNotifier

## Technical Stack

- **Flutter & Dart**: Core framework and programming language
- **flutter_riverpod**: Provider-based state management
- **Open-Meteo API**: Free weather data provider
- **geolocator**: Location services
- **http**: API communication
- **mocktail**: Unit testing mocks

## Architecture

The project follows Clean Architecture principles with the following layers:

```bash
lib/
├── models/         # Data models
├── repositories/   # Data sources and API handling
├── providers/      # Business logic and state management
└── screens/        # UI components
```

## State Management

Riverpod StateNotifier drives the app's weather flow with:
- Explicit async state via `AsyncValue`
- Built-in dependency injection for repositories
- Decoupled controller logic that is simple to unit test
- Scoped listeners for transient UI messaging

## Testing

Run the automated suite with FVM to ensure consistent Flutter tooling:

```bash
fvm flutter test
```

## Platform Support

- ✅ Android
- ✅ iOS

## Future Improvements

- [ ] Add more diving locations in Malaysia
- [x] Implement weather forecasting
- [ ] Add water temperature data
- [ ] Include tide information
- [ ] Save favorite locations
