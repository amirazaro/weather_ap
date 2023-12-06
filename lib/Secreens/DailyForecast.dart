import 'package:flutter/material.dart';
import 'package:weather_app/NavBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DailyForecast extends StatefulWidget {
  const DailyForecast({Key? key}) : super(key: key);

  @override
  _DailyForecastState createState() => _DailyForecastState();
}

class _DailyForecastState extends State<DailyForecast> {
  static String API_KEY = "a3fe293ff5fb45a39e3131839230112";

  List<Map<String, dynamic>> dailyWeatherForecast = [];

  // api calling
  String dailyForecastAPI =
      "http://api.weatherapi.com/v1/forecast.json?key=" + API_KEY + "&days=7&q=";

  void fetchDailyForecast(String searchText) async {
    try {
      var forecastResult =
      await http.get(Uri.parse(dailyForecastAPI + searchText));

      final forecastData = Map<String, dynamic>.from(
        json.decode(forecastResult.body),
      );

      setState(() {
        dailyWeatherForecast = (forecastData["forecast"]["forecastday"]as List )
        .cast<Map<String, dynamic>>();
      });
    } catch (e) {
      // Handle error
      print("Error :$e");
    }
  }

  @override
  void initState() {

    fetchDailyForecast("Hebron");
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
          '7 Day Daily Forecast',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView.builder(
        itemCount: dailyWeatherForecast.length,
        itemBuilder: (context, index) {
          return _buildDailyForecastCard(dailyWeatherForecast[index]);
        },
      ),
    );
  }

  Widget _buildDailyForecastCard(Map<String, dynamic> dayForecast) {
    String weatherIconUrl = dayForecast["day"]["condition"]["icon"].replaceAll('//', 'https://');

    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Image.network(
          weatherIconUrl,
          height: 40,
          width: 40,
        ),
        title: Text(
          '${dayForecast["date"]}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(

          'High: ${dayForecast["day"]["maxtemp_c"]}°C, Low: ${dayForecast["day"]["mintemp_c"]}°C',
          style: TextStyle(fontSize: 16),
        ),

        onTap: () {
        },
      ),
    );
  }

}