import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_model.dart';

class ForecastSection extends StatelessWidget {
  final Weather weather;
  const ForecastSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '7-Day Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: weather.forecast.length,
              itemBuilder: (context, index) {
                final forecast = weather.forecast[index];

                return Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Day
                        Text(
                          DateFormat('EEE').format(forecast.date),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Date
                        Text(
                          DateFormat('MMM d').format(forecast.date),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                        const Divider(color: Colors.white30),

                        // Max Temp
                        ForecastItem(
                            label: 'Max Temp: ${forecast.maxTemp.round()}°'),

                        // Min Temp
                        ForecastItem(
                            label: 'Min Temp: ${forecast.minTemp.round()}°'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

// reusable widget for forecast items
class ForecastItem extends StatelessWidget {
  final String label;
  const ForecastItem({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Colors.white),
    );
  }
}
