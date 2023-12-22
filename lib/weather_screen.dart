import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:list_product/component/card_additional_information.dart';
import 'package:list_product/component/card_weather.dart';
import 'package:list_product/component/center_loading.dart';

class WeatherScreen extends StatelessWidget {
  final Future<Map<String, dynamic>> weather;

  const WeatherScreen({super.key, required this.weather});

  // String cityName = 'London,uk';
  @override
  Widget build(BuildContext context) {
    const globalSizeBox = SizedBox(
      height: 16,
    );

    const bigSizeBox = SizedBox(
      height: 20,
    );

    return FutureBuilder(
      future: weather,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CenterLoading();
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        final data = snapshot.data!;
        final curWeatherData = data['list'][0];
        final curSky = curWeatherData['weather'][0]['main'];
        final curTemp = curWeatherData['main']['temp'];
        final curPressure = curWeatherData['main']['pressure'];
        final curHumidity = curWeatherData['main']['humidity'];
        final curWindSpeed = curWeatherData['wind']['speed'];
        final listData = data['list'];
        IconData handleIcon(String type) {
          if (type.toLowerCase() == 'rain') {
            return Icons.water_drop;
          }
          if (type.toLowerCase() == 'clouds') {
            return Icons.cloud;
          }
          return Icons.sunny;
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '$curTemp °K',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                globalSizeBox,
                                Icon(
                                  handleIcon(curSky),
                                  size: 64,
                                ),
                                globalSizeBox,
                                Text(
                                  '$curSky',
                                  style: const TextStyle(fontSize: 22),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  bigSizeBox,
                  const Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  bigSizeBox,
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final dateTime =
                            DateTime.parse(listData[index]['dt_txt']);
                        return CardWeather(
                          time: DateFormat.Hm().format(dateTime),
                          temperature:
                              listData[index]['main']['temp'].toString(),
                          icon:
                              handleIcon(listData[index]['weather'][0]['main']),
                        );
                      },
                      itemCount: listData.length,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardAdditionalInformation(
                        icon: const Icon(
                          Icons.water_drop,
                          size: 32,
                        ),
                        text: 'Humidity',
                        value: '$curHumidity',
                      ),
                      CardAdditionalInformation(
                        icon: const Icon(
                          Icons.wind_power,
                          size: 32,
                        ),
                        text: 'Wind Speed',
                        value: curWindSpeed.toString(),
                      ),
                      CardAdditionalInformation(
                        icon: const Icon(
                          Icons.beach_access,
                          size: 32,
                        ),
                        text: 'Pressure',
                        value: '$curPressure',
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
