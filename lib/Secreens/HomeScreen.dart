import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/NavBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  static String API_KEY = "a3fe293ff5fb45a39e3131839230112";

  String location = 'Hebron';
  String weatherIcon = '';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  // API calling
  String searchWeatherAPI =
      "http://api.weatherapi.com/v1/current.json?key=" + API_KEY + "&q=";

  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));
      final weatherData = Map<String, dynamic>.from(
        json.decode(searchResult.body),
      );

      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];

      setState(() {
        location = locationData["name"];
        var parsedData =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedData);
        currentDate = newDate;

        weatherIcon =
            currentWeather["condition"]["icon"].replaceAll('//', 'https://');
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();

        // Forecast data
        if (weatherData["forecast"] != null &&
            weatherData["forecast"]["forecastday"] != null &&
            weatherData["forecast"]["forecastday"].isNotEmpty) {
          dailyWeatherForecast = weatherData["forecast"]["forecastday"];
          hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        }
      });
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white38,
        title: Text(
          'The Weather In Your City',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Location
              Text(
                location,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Weather Icon
              weatherIcon.isNotEmpty
                  ? Image.network(
                      weatherIcon,
                      height: 80,
                      width: 80,
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 8),

              // Temperature
              Text(
                '$temperature°C',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Windspeed
              Text(
                'Windspeed: $windSpeed km/h',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),

              // Humidity
              Text(
                'Humidity: $humidity%',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),

              // Cloud
              Text(
                'Cloud: $cloud%',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),

              // Current Date
              Text(
                currentDate,
                style: TextStyle(fontSize: 18),
              ),

              // Hourly Forecast
              Column(
                children: hourlyWeatherForecast.map((hour) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '${hour["time"]} - ${hour["temp_c"]}°C',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),

              // Daily Forecast
              Column(
                children: dailyWeatherForecast.map((day) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '${day["date"]} - ${day["day"]["avgtemp_c"]}°C',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
