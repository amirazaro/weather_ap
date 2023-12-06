import 'package:flutter/material.dart';
import 'package:weather_app/Secreens/HomeScreen.dart';

class welcome extends StatelessWidget {
  const welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/lib/IconsFolder/dd.png',fit: BoxFit.cover,),
        ],
      ),

    );
  }
}
