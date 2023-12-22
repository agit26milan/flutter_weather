import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:list_product/component/app_bar.dart';
import 'package:list_product/weather_screen.dart';
import 'package:http/http.dart' as http;
import 'package:list_product/secrets/weather_secret.dart';

void main() {
  runApp(const MyWeatherApp());
}

class MyWeatherApp extends StatefulWidget {
  const MyWeatherApp({super.key});

  @override
  State<MyWeatherApp> createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  String cityName = 'London,uk';
  late Future<Map<String, dynamic>> currentWeather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      var url =
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherApiKey';
      final res = await http.get(Uri.parse(url));
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        showAlert();
        throw data['message'];
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  void onRefresh() {
    setState(() {});
  }

  void onBack() {
    Navigator.of(context).pop();
  }

  void showAlert() {
    AlertDialog alertDialog = AlertDialog(
      title: const Text('Error'),
      content: const Text('API rusak'),
      actions: [TextButton(onPressed: onBack, child: const Text('OK'))],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  @override
  void initState() {
    super.initState();
    currentWeather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: AppBarComponent(
                onRefresh: onRefresh,
              )),
          body: WeatherScreen(weather: getCurrentWeather())),
    );
  }
}
