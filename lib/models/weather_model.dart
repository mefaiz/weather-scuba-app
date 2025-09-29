class WeatherForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int precipitationProbability;
  final double maxWindSpeed;

  WeatherForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitationProbability,
    required this.maxWindSpeed,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json, int index) {
    return WeatherForecast(
      date: DateTime.parse(json['daily']['time'][index]),
      maxTemp: (json['daily']['temperature_2m_max'][index] as num).toDouble(),
      minTemp: (json['daily']['temperature_2m_min'][index] as num).toDouble(),
      precipitationProbability:
          (json['daily']['precipitation_probability_max'][index] as num)
              .toInt(),
      maxWindSpeed:
          (json['daily']['wind_speed_10m_max'][index] as num).toDouble(),
    );
  }
}

class Weather {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int precipitation;
  final String location;
  final List<WeatherForecast> forecast;

  Weather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.location,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // Create list of forecasts
    List<WeatherForecast> forecasts = [];
    for (int i = 0; i < 7; i++) {
      forecasts.add(WeatherForecast.fromJson(json, i));
    }

    return Weather(
      temperature: (json['current']['temperature_2m'] as num).toDouble(),
      feelsLike: (json['current']['apparent_temperature'] as num).toDouble(),
      humidity: (json['current']['relative_humidity_2m'] as num).toInt(),
      windSpeed: (json['current']['wind_speed_10m'] as num).toDouble(),
      precipitation: (json['current']['precipitation'] as num).toInt(),
      location: 'Current Location',
      forecast: forecasts,
    );
  }
}
