import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/providers/weather_controller.dart';
import 'package:weather_app/repositories/weather_repository.dart';

class _MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late WeatherRepository repository;
  late ProviderContainer container;

  Weather buildWeather() {
    return Weather(
      temperature: 25,
      feelsLike: 27,
      humidity: 60,
      windSpeed: 15,
      precipitation: 2,
      location: 'Test Location',
      forecast: const [],
    );
  }

  setUp(() {
    repository = _MockWeatherRepository();
    container = ProviderContainer(
      overrides: [
        weatherRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state has no weather data', () {
    final state = container.read(weatherControllerProvider);
    expect(state.weather, isA<AsyncData<Weather?>>());
    expect(state.weather.value, isNull);
    expect(state.message, isNull);
  });

  test('fetchByCoordinates loads weather data', () async {
    final weather = buildWeather();
    when(() => repository.getWeather(1, 2)).thenAnswer((_) async => weather);

    await container
        .read(weatherControllerProvider.notifier)
        .fetchByCoordinates(latitude: 1, longitude: 2);

    final state = container.read(weatherControllerProvider);
    expect(state.weather, isA<AsyncData<Weather?>>());
    expect(state.weather.value, equals(weather));
    expect(state.message, isNull);
    verify(() => repository.getWeather(1, 2)).called(1);
  });

  test('fetchByCoordinates without coordinates emits message', () async {
    await container
        .read(weatherControllerProvider.notifier)
        .fetchByCoordinates();

    final state = container.read(weatherControllerProvider);
    expect(state.message, 'Please select a location');
    expect(state.weather.value, isNull);
  });

  test('fetchByCoordinates surfaces repository errors', () async {
    when(() => repository.getWeather(any(), any()))
        .thenThrow(Exception('boom'));

    await container
        .read(weatherControllerProvider.notifier)
        .fetchByCoordinates(latitude: 1, longitude: 2);

    final state = container.read(weatherControllerProvider);
    expect(state.weather, isA<AsyncError<Weather?>>());
    expect(state.message, contains('Exception: boom'));
    verify(() => repository.getWeather(1, 2)).called(1);
  });

  test('clearMessage resets message to null', () async {
    final notifier = container.read(weatherControllerProvider.notifier);
    await notifier.fetchByCoordinates();
    expect(container.read(weatherControllerProvider).message,
        'Please select a location');

    notifier.clearMessage();

    final state = container.read(weatherControllerProvider);
    expect(state.message, isNull);
  });
}
