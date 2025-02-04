import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrentPageScreen extends StatelessWidget {
  final String locationName;
  final String countryName;
  final String formattedDate;
  final String showGif;
  final int singleColor;
  final double temperature;
  final String weatherCondition;
  final double feelsLike;

  CurrentPageScreen(
      {super.key,
      required this.locationName,
      required this.countryName,
      required this.formattedDate,
      required this.showGif,
      required this.singleColor,
      required this.temperature,
      required this.weatherCondition,
      required this.feelsLike});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 45,
                  color: Colors.black54,
                ),
                Text(
                  '$locationName${locationName.length > 10 ? ',\n' : ','} ${countryName.length > 15 ? countryName.substring(0, 10) : countryName}',
                  style: TextStyle(
                    fontSize: countryName.length <= 9 && countryName.length >= 1
                        ? 30
                        : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Image.asset(
              showGif,
              width: 250,
              height: 250,
            ),
          ],
        ),
      ),
      bottomSheet: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 300.0,
            decoration: BoxDecoration(
              color: Color(singleColor),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
          ),
          Positioned(
            top: -80,
            width: 320,
            height: 300,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: const BoxDecoration(
                color: Colors.white70,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "$temperature°C",
                    style: GoogleFonts.aDLaMDisplay(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  Text(
                    weatherCondition,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                  Text(
                    "Feel's Like $feelsLike°C",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
