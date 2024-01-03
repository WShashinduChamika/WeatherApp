import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo4/services/database.dart';
import 'package:demo4/services/weather_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WeatherDetails extends StatefulWidget {
  const WeatherDetails({super.key});

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  final WeatherService wservice =
      WeatherService('17616021dbc6c5abe5bb6d8029d52b99');

  String city = "cn";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Color(0xFFFF9100),
              child: ElevatedButton(
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  DocumentSnapshot documentSnapshot =
                      await DatabaseService(uid: user!.uid).getLocation();
                  String latitude = documentSnapshot['latitude'];
                  String longitude = documentSnapshot['longtude'];
                  //print(documentSnapshot['latitude']);
                  try {
                    Map<String, dynamic>? weatherData =
                        await wservice.getWeather(latitude, longitude);
                    print('Weather Data: $weatherData');
                    setState(() {
                      city = '${weatherData?['name']}';
                    });
                  } catch (e) {
                    print('Error fetching weather data: $e');
                  }
                },
                child: Text('get weather data'),
              ),
            ),
            Text(city),
          ],
        ),
      ),
    );
  }
}
