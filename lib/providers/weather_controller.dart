import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import '../repositories/weather_repository.dart';
import 'weather_state.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository();
});

final weatherControllerProvider =
    StateNotifierProvider<WeatherController, WeatherState>((ref) {
  return WeatherController(ref.watch(weatherRepositoryProvider));
});

class WeatherController extends StateNotifier<WeatherState> {
  WeatherController(this._weatherRepository) : super(const WeatherState());

  final WeatherRepository _weatherRepository;

  Future<void> fetchByCoordinates({
    double? latitude,
    double? longitude,
  }) async {
    if (latitude == null || longitude == null) {
      state = state.copyWith(message: 'Please select a location');
      return;
    }

    await _loadWeather(() => _weatherRepository.getWeather(latitude, longitude));
  }

  Future<void> fetchCurrentLocationWeather() async {
    await _loadWeather(() async {
      final position = await _getCurrentLocation();
      return _weatherRepository.getWeather(
        position.latitude,
        position.longitude,
      );
    });
  }

  void clearMessage() {
    state = state.clearMessage();
  }

  Future<void> _loadWeather(Future<Weather> Function() loader) async {
    state = state.copyWith(
      weather: const AsyncValue.loading(),
      clearMessage: true,
    );

    final result = await AsyncValue.guard(loader);
    final normalized = result.whenData<Weather?>((value) => value);
    state = state.copyWith(weather: normalized);

    final error = normalized.asError;
    if (error != null) {
      state = state.copyWith(message: error.error.toString());
    }
  }

  Future<Position> _getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, please enable them in settings.',
      );
    }

    return Geolocator.getCurrentPosition();
  }
}
