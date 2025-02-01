import 'package:flutter/material.dart';
import 'package:smart_weather_app/weather_app_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: "Smart Weather App",
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyMedium: GoogleFonts.ubuntu(textStyle: textTheme.bodyMedium),
        ),
      ),
      home: WeatherAppScreen(),
    );
  }
}
