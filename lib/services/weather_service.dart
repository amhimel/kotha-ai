import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kotha_ai/model/weather_model.dart';

class WeatherService {
  static const String _apiKey = '1974478d392460bcd2fc7cee56ec6d72';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel?> fetchWeatherByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherModel.fromJson(json);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception while fetching weather: $e");
      return null;
    }
  }

  Future<WeatherModel?> fetchWeatherByLocation(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherModel.fromJson(json);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception while fetching weather: $e");
      return null;
    }
  }


}
