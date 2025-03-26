import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLightMode = false;
  bool isCelsius = true;
  String _location = "Santa Ana";

  void toggleLightMode(bool value) {
    setState(() {
      isLightMode = value;
    });
  }

  void toggleTemperatureUnit(bool value) {
    setState(() {
      isCelsius = value;
      getData();
    });
  }

  void updateLocation(String newLocation) {
    setState(() {
      _location = newLocation;
      getData();
    });
  }

  Map<String, dynamic> weatherData = {};
  // String url = "https://api.openweathermap.org/data/2.5/weather?q=arayat&appid=71039c9eb96817fb861a01cee2b13766";
  String city = "Loading...";
  String temperature = "----";
  String humidity = "----";
  String feels = "----";
  String description = '';
  String backgroundAsset = 'images/bg.jpg'; 

  String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  IconData? weather;
Future<void> getData() async {
  final response = await http.get(Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$_location&appid=71039c9eb96817fb861a01cee2b13766"));

  setState(() {
    if (response.statusCode == 200) {
      weatherData = jsonDecode(response.body);
      city = weatherData["name"];

      double tempInCelsius = weatherData["main"]["temp"] - 273.15;
      double feelsLikeCelsius = weatherData["main"]["feels_like"] - 273.15;

      if (isCelsius) {
        temperature = "${tempInCelsius.toStringAsFixed(1)}°C";
        feels = "${feelsLikeCelsius.toStringAsFixed(1)}°C";
      } else {
        temperature = "${((tempInCelsius * 9 / 5) + 32).toStringAsFixed(1)}°F";
        feels = "${((feelsLikeCelsius * 9 / 5) + 32).toStringAsFixed(1)}°F";
      }

      humidity = "${weatherData["main"]["humidity"]}%";

         switch (weatherData["weather"][0]["main"]) {
          case "Clouds":
            weather = CupertinoIcons.cloud;
            backgroundAsset = 'images/bg.jpg';
             description = "Cloudy";
            break;
          case "Clear":
            weather = CupertinoIcons.sun_max;
            backgroundAsset = 'images/clear.jpg';
             description = "Clear Sky";
            break;
          case "Mist":
            weather = CupertinoIcons.cloud_rain;
            backgroundAsset = 'images/mist.jpg';
             description = "Misty";
            break;
          case "Rain":
            weather = CupertinoIcons.cloud_bolt_rain;
            backgroundAsset = 'images/rain.jpg';
             description = "Rainy";
            break;
          case "Snow":
            weather = CupertinoIcons.snow;
            backgroundAsset = 'images/snow.jpg';
             description = "Snowy";
            break;
          case "Thunderstorm":
            weather = CupertinoIcons.cloud_bolt;
            backgroundAsset = 'images/thunderstorm.jpg';
             description = "Thunderstorms";
            break;
          case "Drizzle":
            weather = CupertinoIcons.cloud_drizzle;
            backgroundAsset = 'images/drizzle.jpg';
             description = "Drizzle";
            break;
          default:
            weather = CupertinoIcons.cloud;
            backgroundAsset = 'images/bg.jpg'; 
             description = "Cloudy";
            break;
         }
    } else {
       backgroundAsset = 'images/bg.jpg';
      city = "Location not found";
      temperature = "----";
      humidity = "----";
      feels = "----";
      description = "";
      weather = null;
    }
  });
}
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(brightness: isLightMode ? Brightness.light : Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: Navigator(
        onGenerateRoute: (settings) {
          return CupertinoPageRoute(
            builder: (context) => CupertinoPageScaffold(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(backgroundAsset),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 100),
                           CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Icon(CupertinoIcons.settings, color: Colors.white, size: 30),
                              onPressed: () {
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Container(
                          padding: EdgeInsets.fromLTRB(95, 35, 95, 80),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Current',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                'WEATHER',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(height: 35),
                              Text(
                                city,
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              Text(
                                formattedDate,
                                style: TextStyle(fontSize: 18, color: Colors.white70),
                              ),
                              SizedBox(height: 16),
                              Icon(
                                weather,
                                size: 100,
                                color: Colors.white,
                              ),
                              Text(
                                description,
                                style: TextStyle(fontSize: 18, color: Colors.white70),
                              ),
                              SizedBox(height: 40),
                              Text(
                                temperature,
                                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'H: $humidity  L: $feels',
                                style: TextStyle(fontSize: 20, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}