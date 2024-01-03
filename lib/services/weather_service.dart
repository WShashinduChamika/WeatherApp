import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  WeatherService(this.apiKey);
  //
  Future<Map<String, dynamic>> getWeather(
      String latitude, String longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey'));
    if (response.statusCode == 200) {
      // Successful API call
      return json.decode(response.body);
    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Throw an exception with a descriptive message
      throw Exception(
          'Failed to load weather data. Status code: ${response.statusCode}');
    }
  }
}
