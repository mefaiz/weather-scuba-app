import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weather_app/models/diving_spot_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/providers/weather_controller.dart';
import 'package:weather_app/providers/weather_state.dart';
import 'package:weather_app/screens/appbar.dart';
import 'package:weather_app/screens/bg_color.dart';
import 'package:weather_app/screens/forecast.dart';
import 'package:weather_app/screens/scuba_description.dart';
import 'package:weather_app/screens/weather_initial.dart';
import 'package:weather_app/screens/weather_items.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  List<DivingSpot>? _divingSpots;
  DivingSpot? _selectedSpot;

  @override
  void initState() {
    super.initState();
    _loadDivingSpots();
  }

  Future<void> _loadDivingSpots() async {
    final jsonString = await rootBundle.loadString('assets/diving_spots.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    setState(() {
      _divingSpots = (data['diving_spots'] as List)
          .map((spot) => DivingSpot.fromJson(spot))
          .toList();
      _selectedSpot = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<WeatherState>(weatherControllerProvider, (previous, next) {
      final message = next.message;
      if (message != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
          ),
        );
        ref.read(weatherControllerProvider.notifier).clearMessage();
      }
    });

    final weatherState = ref.watch(weatherControllerProvider);

    return Scaffold(
      body: BodyBackgroundColor(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const CustomAppBar(),
              if (_divingSpots != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<DivingSpot?>(
                        value: _selectedSpot,
                        hint: const Text(
                          'Please Select Location',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        isExpanded: true,
                        dropdownColor: const Color(0xFF1E88E5),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        items: [
                          ...?_divingSpots?.map((spot) {
                            return DropdownMenuItem(
                              value: spot,
                              child: Text(
                                spot.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }),
                        ],
                        onChanged: (DivingSpot? spot) {
                          setState(() {
                            _selectedSpot = spot;
                          });
                          if (spot != null) {
                            ref.read(weatherControllerProvider.notifier)
                              .fetchByCoordinates(
                                latitude: spot.latitude,
                                longitude: spot.longitude,
                              );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              if (_selectedSpot != null)
                ScubaDescription(description: _selectedSpot!.description),
              Expanded(
                child: weatherState.weather.when(
                  data: (weather) {
                    if (weather == null) {
                      return const UIInitial();
                    }
                    return _WeatherContent(weather: weather);
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  error: (error, stackTrace) {
                    return const UIInitial();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${weather.temperature.round()}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  WeatherItem(
                    icon: Icons.thermostat,
                    label: 'Feels like',
                    value: '${weather.feelsLike.round()}°C',
                  ),
                  WeatherItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: '${weather.humidity}%',
                  ),
                  WeatherItem(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: '${weather.windSpeed} km/h',
                  ),
                  WeatherItem(
                    icon: Icons.umbrella,
                    label: 'Precipitation',
                    value: '${weather.precipitation} mm',
                  ),
                ],
              ),
            ),
          ),
          ForecastSection(weather: weather),
        ],
      ),
    );
  }
}
