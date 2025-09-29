import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather_model.dart';

class WeatherState {
  const WeatherState({
    this.weather = const AsyncValue<Weather?>.data(null),
    this.message,
  });

  final AsyncValue<Weather?> weather;
  final String? message;

  WeatherState copyWith({
    AsyncValue<Weather?>? weather,
    String? message,
    bool clearMessage = false,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  WeatherState clearMessage() => copyWith(clearMessage: true);

  bool get hasWeather =>
      weather is AsyncData<Weather?> && weather.value != null;

  Weather? get data => weather is AsyncData<Weather?> ? weather.value : null;
}
