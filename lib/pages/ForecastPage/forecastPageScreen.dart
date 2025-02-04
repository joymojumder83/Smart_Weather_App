import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ForecastPageScreen extends StatelessWidget {
  final String locationName;
  final String countryName;
  final String formattedDate;
  final String showGif;
  final int singleColor;
  final double temperature;
  final String weatherCondition;
  final double windSpeed;
  final num humidity;
  final List forecastList;

  ForecastPageScreen({
    super.key,
    required this.locationName,
    required this.countryName,
    required this.formattedDate,
    required this.showGif,
    required this.singleColor,
    required this.temperature,
    required this.weatherCondition,
    required this.windSpeed,
    required this.humidity,
    required this.forecastList,
  });

  @override
  Widget build(BuildContext context) {
    List<String> forecastDates = [];

    forecastList.forEach(
      (element) {
        DateTime now = DateTime.parse(element['date']);
        final String formattedDates = DateFormat('EEEE').format(now);
        forecastDates.add(formattedDates);
      },
    );

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              showGif,
              width: 200,
            ),
          )
        ],
      ),
      bottomSheet: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 500.0,
            decoration: BoxDecoration(
              color: Color(singleColor),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
          ),
          Positioned(
            top: -40,
            width: 340,
            height: 140.0,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$temperature°C",
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        weatherCondition,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Wind Speed",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        windSpeed.toString() + " km/h",
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Humidity",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        humidity.toString() + "%",
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 120,
            width: 340,
            height: 340,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var forecast in forecastList)
                      Row(
                        children: [
                          Image(
                            image: NetworkImage(
                              'https:${forecast['day']['condition']['icon']}',
                            ),
                            width: 40,
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(
                                forecastDates[forecastList.indexOf(forecast)],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                forecast['day']['condition']['text'],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            forecast['day']['avgtemp_c'].toString() + "°C",
                            style: GoogleFonts.aDLaMDisplay(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                          ),
                          Spacer(),
                          Text(
                            forecast['day']['avghumidity'].toString() + "%",
                            style: GoogleFonts.aDLaMDisplay(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
