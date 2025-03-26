import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
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
                        image: AssetImage('images/bg.jpg'),
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
                              onPressed: ()  {
                               
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
                              ),
                              Text(
                                'WEATHER',
                              ),
                              SizedBox(height: 35),
                              Text(
                                city,
                              ),
                              SizedBox(height: 5),
                              Text(
                                date,
                              ),
                              SizedBox(height: 16),
                              Icon(
                                weather,
                                size: 100,
                              ),
                              Text(
                                description,
                                style: TextStyle(fontSize: 18, color: Colors.white70),
                              ),
                              SizedBox(height: 40),
                              Text(
                                temperature,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'H: $humidity  L: $feels',
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