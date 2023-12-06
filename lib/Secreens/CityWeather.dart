import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/NavBar.dart';

class CityWeather extends StatefulWidget {
  const CityWeather({Key? key}) : super(key: key);

  @override
  State<CityWeather> createState() => _CityWeatherState();
}

class _CityWeatherState extends State<CityWeather> {
  List<String> cityNames = ['City0', 'City1', 'City2', 'City3', 'City4', 'City5'];
  List<int> temperatures = List.filled(6, 0);
  List<String> weatherDescriptions = List.filled(6, '');

  static String API_KEY = "a3fe293ff5fb45a39e3131839230112";
  String weatherAPI = "http://api.weatherapi.com/v1/current.json?key=$API_KEY&q=";

  @override
  void initState() {
    super.initState();
    // Fetch weather data for each city
    for (int i = 0; i < cityNames.length; i++) {
      fetchWeatherData(cityNames[i], i);
    }
  }

  void fetchWeatherData(String cityName, int index) async {
    try {
      var weatherResult = await http.get(Uri.parse(weatherAPI + cityName));
      final weatherData = Map<String, dynamic>.from(json.decode(weatherResult.body));

      setState(() {

        temperatures[index] = weatherData['current']['temp_c'].toInt();
        weatherDescriptions[index] = weatherData['current']['condition']['text'];
      });
    } catch (e) {
      print("Error fetching weather data for $cityName: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white38,
        title: Text(
          'City Weather Information',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView.builder(
        itemCount: cityNames.length,
        itemBuilder: (context, index) {
          return _buildCityCard(cityNames[index], temperatures[index], weatherDescriptions[index]);
        },
      ),
    );
  }
}

Widget _buildCityCard(String cityName, int temperature, String weatherDescription) {
  return Card(
    margin: EdgeInsets.all(8),
    child: ListTile(
      title: Text(
        cityName,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temperature: $temperature°C',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Weather: $weatherDescription',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      onTap: () {},
    ),
  );
}
