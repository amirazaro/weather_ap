import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/NavBar.dart';

class HourlyForecast extends StatefulWidget {
  const HourlyForecast({Key? key}) : super(key: key);

  @override
  _HourlyForecastState createState() => _HourlyForecastState();
}

class _HourlyForecastState extends State<HourlyForecast> {
  static String API_KEY = "a3fe293ff5fb45a39e3131839230112";

  List<Map<String, dynamic>> hourlyWeatherForecast = [];

  // api calling
  String hourlyForecastAPI =
      "http://api.weatherapi.com/v1/forecast.json?key=" + API_KEY + "&hours=24&q=";

  void fetchHourlyForecast(String searchText) async {
    try {
      var forecastResult =
      await http.get(Uri.parse(hourlyForecastAPI + searchText));
      final forecastData = json.decode(forecastResult.body);

      if (forecastData.containsKey("error")) {
        // Handle API error
        print("API Error: ${forecastData["error"]["message"]}");
        return;
      }

      setState(() {
        hourlyWeatherForecast = (forecastData["forecast"]["forecastday"][0]["hour"] as List)
            .cast<Map<String, dynamic>>();
      });

      print("Hourly Forecast Data: $hourlyWeatherForecast");
    } catch (e) {
      // Handle other errors
      print("Error: $e");
    }
  }

  @override
  void initState() {

    fetchHourlyForecast("Hebron");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white38,
        title: Text(
          'Hourly Forecast',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView.builder(
        itemCount: hourlyWeatherForecast.length,
        itemBuilder: (context, index) {
          return _buildHourlyForecastCard(hourlyWeatherForecast[index]);
        },
      ),
    );
  }

  Widget _buildHourlyForecastCard(Map<String, dynamic> hourForecast) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(

          '${hourForecast["time"]}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(

          'Temperature: ${hourForecast["temp_c"]}°C',
          style: TextStyle(fontSize: 16),
        ),
        leading: Image.network(

          'https:${hourForecast["condition"]["icon"]}',
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
