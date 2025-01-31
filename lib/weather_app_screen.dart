import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherAppScreen extends StatefulWidget {
  const WeatherAppScreen({super.key});

  @override
  State<WeatherAppScreen> createState() => _WeatherAppScreenState();
}

class _WeatherAppScreenState extends State<WeatherAppScreen> {
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  Future fetchWeatherApi() async {
    try {
      String cityName = "Bangladesh";
      final String url =
          "http://api.weatherapi.com/v1/current.json?key=3cdcd96882c445cfbaa121359253101&q=$cityName";
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      final body = response.body;
      final json = jsonDecode(body);
      if (json["cod"] != "200") {
        return Future.delayed(Duration(seconds: 2), () => json);
      } else {
        throw "Unsparted Error Occured";
      }
    } catch (e) {
      throw "Unsparted Error Occured";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWeatherApi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Image(
                image: AssetImage("assets/images/weather_loading_icon.gif"),
                width: 300,
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/images/error_ocured.gif"),
                    width: 300,
                  ),
                  Text(
                    snapshot.error.toString(),
                    style: GoogleFonts.ubuntu(
                      color: Colors.redAccent,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                icon: const Icon(Icons.menu_rounded),
                iconSize: 45,
                elevation: 10,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                color: Colors.white70,
                iconColor: Colors.black54,
                itemBuilder: (BuildContext context) {
                  return {'Logout', 'Settings', 'Help'}.map((String choice) {
                    return PopupMenuItem<String>(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                      value: choice,
                      child: Text(
                        choice,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
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
                      "joy",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Man, 20 Mar 2023',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Image.asset(
                  'assets/images/sunny_gif.gif',
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
                  color: const Color.fromARGB(255, 255, 193, 36),
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
                        "25°C",
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        "Sunny",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        "Feel's Like 26°C",
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
      },
    );
  }
}
