import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherRepository {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  // Get weather data for a specific location
  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl?latitude=$lat&longitude=$lon'
        '&current=temperature_2m,relative_humidity_2m,apparent_temperature,'
        'precipitation,wind_speed_10m'
        '&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max,'
        'wind_speed_10m_max'
        '&forecast_days=7'
        '&timezone=auto',
      ),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
