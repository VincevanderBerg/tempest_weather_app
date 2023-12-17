// Comments:
//
// This model should store data returned by the weather API.
//
class Weather {
  const Weather({required this.temperature, required this.weatherCode});

  final double temperature;
  final double weatherCode;
}
