import 'package:flutter/material.dart';
import 'package:weather_app/Secreens/HomeScreen.dart';
import 'package:weather_app/Secreens/welcome.dart';

import 'NavBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomeScreen(),
      );
  }
}



