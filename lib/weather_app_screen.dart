import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

  final SearchController _searchController = SearchController();

  Future<Map<String, dynamic>> fetchWeatherApi() async {
    try {
      String cityName = "auto:ip";
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                image: AssetImage("assets/gifs/weather_loading_icon.gif"),
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
                    image: AssetImage("assets/gifs/error_ocured.gif"),
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

        final String locationTimezone = snapshot.data!["location"]["localtime"];
        DateTime now = DateTime.parse(locationTimezone);
        final String formattedDate = DateFormat('EEEE, d MMM').format(now);

        final double temperature = snapshot.data!["current"]["temp_c"];
        final int isDay = snapshot.data!["current"]["is_day"];
        final String weatherCondition =
            snapshot.data!["current"]["condition"]["text"];

        final String locationName = snapshot.data!["location"]["name"];
        final String countryName = snapshot.data!["location"]["country"];
        // location name length condition for controlling font size
        double locationNameLength;
        if (countryName.length <= 9 && countryName.length >= 1) {
          locationNameLength = 32;
        } else if (countryName.length <= 12 && countryName.length >= 10) {
          locationNameLength = 28;
        } else if (countryName.length <= 15 && countryName.length >= 13) {
          locationNameLength = 25;
        } else if (countryName.length <= 18 && countryName.length >= 16) {
          locationNameLength = 22;
        } else {
          locationNameLength = 20;
        }

        // gif condition and color condition for more ui control
        final colorAll = (
          0xFFFFAE0B,
          0xFF6034FF,
          0xFFAE00DF,
          0xFF0597FF,
          0xFF3B0066,
          0xFF21FFDA,
          0xFF8D8D8D,
          0xFF7D9BFF,
          0xFFFF2C6B,
          0xFF7900D0,
        );
        int singleColor = colorAll.$1;

        String showGif = "";
        switch (weatherCondition) {
          case "Sunny":
            showGif = "assets/gifs/sunny_gif.gif";
            singleColor = colorAll.$1;
          case "Cloudy":
            showGif = "assets/gifs/weather_cloudy.gif";
            singleColor = colorAll.$2;
          case "Overcast" when isDay == 1:
            showGif = "assets/gifs/weather_overcast.gif";
            singleColor = colorAll.$3;
          case "Partly cloudy" when isDay == 1:
            showGif = "assets/gifs/weather_partlycloudy.gif";
            singleColor = colorAll.$4;
          case "Partly cloudy" when isDay == 0:
            showGif = "assets/gifs/weather_night.gif";
            singleColor = colorAll.$10;
          case "Clear" when isDay == 0 || isDay == 0:
            showGif = "assets/gifs/weather_night.gif";
            singleColor = colorAll.$5;
          case "Rain" || "Light rain":
            showGif = "assets/gifs/weather_rainy.gif";
            singleColor = colorAll.$6;
          case "Foggy" || "Mist":
            showGif = "assets/gifs/weather_foggy.gif";
            singleColor = colorAll.$7;
          case "Snow":
            showGif = "assets/gifs/weather_snow.gif";
            singleColor = colorAll.$8;
          case "Storm":
            showGif = "assets/gifs/weather_storm.gif";
            singleColor = colorAll.$9;
        }
        final double feelsLike = snapshot.data!["current"]["feelslike_c"];

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
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
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: SizedBox(
                width: 200,
                child: SearchAnchor(
                  builder: (context, controller) {
                    return SearchBar(
                      controller: _searchController,
                      hintText: "Search City",
                      onTap: () => controller.openView(),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.search,
                      textStyle: WidgetStatePropertyAll(
                        TextStyle(
                          color: isDay == 1 ? Colors.black87 : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      hintStyle: WidgetStatePropertyAll(
                        TextStyle(
                          color: isDay == 1 ? Colors.black87 : Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor:
                          WidgetStatePropertyAll(Color(singleColor)),
                      shadowColor: WidgetStatePropertyAll(Colors.black87),
                      elevation: WidgetStatePropertyAll(5),
                      padding: WidgetStatePropertyAll(EdgeInsets.all(10)),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      leading: Icon(
                        Icons.search_rounded,
                        color: isDay == 1 ? Colors.black87 : Colors.white70,
                        size: 35,
                      ),
                    );
                  },
                  suggestionsBuilder: (context, controller) {
                    return ["London", "New York", "Tokyo"].map(
                      (suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                          onTap: () {
                            controller.clear();
                            setState(() {
                              _searchController.text = suggestion;
                            });
                          },
                        );
                      },
                    ).toList();
                  },
                  viewBackgroundColor: Colors.white54,
                  viewOnSubmitted: (value) => setState(() {
                    _searchController.text = value;
                  }),
                  viewHintText: "Search Location",
                ),
              ),
            ),
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
                      '$locationName, $countryName',
                      style: TextStyle(
                        fontSize: locationNameLength,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 20,
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
      },
    );
  }
}
