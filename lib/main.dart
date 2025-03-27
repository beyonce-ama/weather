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
   String windSpeed = "----";
  String cloudiness = "----";
  String pressure = "----";
  String visibility = "----";
  String sunrise = "----";
  String sunset = "----";
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
      windSpeed = "${weatherData["wind"]["speed"]} m/s";
        cloudiness = "${weatherData["clouds"]["all"]}%";
        pressure = "${weatherData["main"]["pressure"]} hPa";
        visibility = "${(weatherData["visibility"] / 1000).toStringAsFixed(1)} km";

        DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(weatherData["sys"]["sunrise"] * 1000);
        DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(weatherData["sys"]["sunset"] * 1000);
        sunrise = DateFormat('hh:mm a').format(sunriseTime);
        sunset = DateFormat('hh:mm a').format(sunsetTime);

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
    theme: CupertinoThemeData(
      brightness: isLightMode ? Brightness.light : Brightness.dark,
    ),
    debugShowCheckedModeBanner: false,
    home: LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = constraints.maxWidth * 0.8;
        double containerPadding = constraints.maxWidth * 0.1;
        
        return Navigator(
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
                      padding: EdgeInsets.all(containerPadding * 0.5),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Icon(
                                    CupertinoIcons.settings,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    final newLocation = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => SettingsPage(
                                          isLightMode: isLightMode,
                                          onLightModeChanged: toggleLightMode,
                                          isCelsius: isCelsius,
                                          onTemperatureUnitChanged: toggleTemperatureUnit,
                                          location: _location,
                                          onLocationChanged: (String location) {},
                                        ),
                                      ),
                                    );
                                    if (newLocation != null && newLocation != _location) {
                                      setState(() {
                                        _location = newLocation;
                                        getData();
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Container(
                              width: containerWidth,
                              padding: EdgeInsets.symmetric(
                                vertical: constraints.maxHeight * 0.05,
                                horizontal: containerPadding,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Weather',
                                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 15),
                        
                                // City & Date
                                Text(city, style: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.bold)),
                                Text(formattedDate, style: TextStyle(fontSize: 16, color: Colors.white70)),
                        
                                SizedBox(height: 15),
                        
                                // Weather Icon & Description
                                Icon(weather, size: 90, color: Colors.white),
                                SizedBox(height: 5),
                                Text(description, style: TextStyle(fontSize: 18, color: Colors.white70)),
                        
                                SizedBox(height: 5),
                        
                                // Temperature
                                Text(temperature, style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                        
                                SizedBox(height: 30),
                        
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                                              
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: weatherDetail("Feels Like", feels)),
                                      SizedBox(width: 55),
                                      Expanded(child: weatherDetail("Humidity", humidity)),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: weatherDetail("Wind", windSpeed)),
                                      SizedBox(width: 55),
                                      Expanded(child: weatherDetail("Cloud Cover", cloudiness)),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: weatherDetail("Visibility", visibility)),
                                      SizedBox(width: 55),
                                      Expanded(child: weatherDetail("Pressure", pressure)),
                                    ],
                                  ),
                                                              ],
                                                            ),
                                ),
                              ],
                            ),
                        
                        
                              ),
                            ],
                          ),
                      ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Helper function to create weather detail tiles
Widget weatherDetail(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 14, color: Colors.white70)),
      SizedBox(height: 3),
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    ],
  );
}
