import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:country_data/country_data.dart';
import 'package:smart_weather_app/pages/CurrentPage/currentPageScreen.dart';
import 'package:smart_weather_app/pages/ForecastPage/forecastPageScreen.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:flutter/foundation.dart';

class WeatherAppScreen extends StatefulWidget {
  const WeatherAppScreen({super.key});

  @override
  State<WeatherAppScreen> createState() => _WeatherAppScreenState();
}

class _WeatherAppScreenState extends State<WeatherAppScreen> {
  bool isForecast = false;
  List<Country> countries = CountryData().getCountries();

  @override
  void initState() {
    super.initState();

    UnityAds.init(
      gameId: defaultTargetPlatform == TargetPlatform.android
          ? "${dotenv.env["android_ads_code"]}"
          : '${dotenv.env["ios_ads_code"]}',
      onComplete: () {
        UnityAds.load(
          placementId: 'Rewarded_Android',
        );
        UnityAds.load(
          placementId: 'Interstitial_Android',
        );
        UnityAds.load(
          placementId: 'Banner_Android',
        );
      },
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Current Weather':
        setState(() {
          isForecast = false;
        });
        Future.delayed(
          Duration(seconds: 1),
          () {
            UnityAds.load(
              placementId: "Interstitial_Android",
              onComplete: (placementId) {
                UnityAds.showVideoAd(placementId: placementId);
              },
            );
          },
        );
        break;
      case 'Forecast Weather':
        setState(() {
          isForecast = true;
        });
        Future.delayed(
          Duration(seconds: 1),
          () {
            UnityAds.load(
              placementId: "Rewarded_Android",
              onComplete: (placementId) {
                UnityAds.showVideoAd(placementId: placementId);
              },
            );
          },
        );
        break;
    }
  }

  final SearchController _searchController = SearchController();

  Future<Map<String, dynamic>> fetchWeatherApi() async {
    String cityName = isForecast ? "London" : "auto:ip";
    try {
      if (_searchController.text.isNotEmpty) {
        String capitalizeText = _searchController.text[0].toUpperCase() +
            _searchController.text.substring(1);

        if (countries.map((e) => e.capital).contains(capitalizeText) ||
            countries.map((e) => e.name).contains(capitalizeText)) {
          cityName = _searchController.text;
        }
      }

      final String url =
          "http://api.weatherapi.com/v1/forecast.json?key=${dotenv.env["weather_api_key"]}&days=7&q=$cityName";

      final uri = Uri.parse(url);
      final response = await http.get(uri);

      final body = response.body;
      final json = jsonDecode(body);

      if (json["cod"] != "200") {
        return json;
      } else {
        throw "Internal Server Error";
      }
    } catch (e) {
      throw "Unspacted Error Occured";
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

        final double windSpeed = snapshot.data!["current"]["wind_kph"];
        final num humidity = snapshot.data!["current"]["humidity"];
        final List forcasterDays = snapshot.data!["forecast"]["forecastday"];

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
          case "Clear" when isDay == 0:
            showGif = "assets/gifs/weather_night.gif";
            singleColor = colorAll.$5;
          case "Rain" ||
                "Light rain" ||
                "Heavy rain" ||
                "Patchy rain nearby" ||
                "Moderate rain":
            showGif = "assets/gifs/weather_rainy.gif";
            singleColor = colorAll.$6;
          case "Foggy" || "Mist" || "Patchy fog" || "Fog":
            showGif = "assets/gifs/weather_foggy.gif";
            singleColor = colorAll.$7;
          case "Snow":
            showGif = "assets/gifs/weather_snow.gif";
            singleColor = colorAll.$8;
          case "Storm":
            showGif = "assets/gifs/weather_storm.gif";
            singleColor = colorAll.$9;
          default:
            showGif = "assets/gifs/sunny_gif.gif";
            singleColor = colorAll.$1;
        }
        final double feelsLike = snapshot.data!["current"]["feelslike_c"];

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: isForecast
                ? Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 30,
                        color: Colors.black54,
                      ),
                      Text(
                        '$locationName, ${countryName.length > 15 ? countryName.substring(0, 10) : countryName}',
                        style: TextStyle(
                          fontSize: locationName.length <= 9 &&
                                  locationName.length >= 1
                              ? 22
                              : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  )
                : null,
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                icon: const Icon(Icons.menu_rounded),
                iconSize: 45,
                elevation: 10,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                color: Colors.white,
                iconColor: Colors.black54,
                itemBuilder: (BuildContext context) {
                  return {'Current Weather', 'Forecast Weather'}
                      .map((String choice) {
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
                  searchController: _searchController,
                  suggestionsBuilder: (context, controller) {
                    return countries.map(
                      (suggestion) {
                        return ListTile(
                          title:
                              Text("${suggestion.emoji} ${suggestion.capital}"),
                          onTap: () {
                            setState(() {
                              controller.clear();
                              _searchController.text = suggestion.capital;
                            });
                          },
                        );
                      },
                    );
                  },
                  viewBackgroundColor: Colors.white54,
                  viewElevation: 5,
                  viewOnSubmitted: (value) => setState(() {
                    _searchController.text = value;
                  }),
                  viewHintText: "Search Location",
                ),
              ),
            ),
          ),
          body: isForecast == true
              ? ForecastPageScreen(
                  locationName: locationName,
                  countryName: countryName,
                  formattedDate: formattedDate,
                  showGif: showGif,
                  singleColor: singleColor,
                  temperature: temperature,
                  windSpeed: windSpeed,
                  weatherCondition: weatherCondition,
                  humidity: humidity,
                  forecastList: forcasterDays,
                )
              : CurrentPageScreen(
                  locationName: locationName,
                  countryName: countryName,
                  formattedDate: formattedDate,
                  showGif: showGif,
                  singleColor: singleColor,
                  temperature: temperature,
                  feelsLike: feelsLike,
                  weatherCondition: weatherCondition,
                ),
          bottomNavigationBar: UnityBannerAd(
            placementId: 'Banner_Android',
          ),
        );
      },
    );
  }
}
