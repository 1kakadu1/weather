import 'dart:io';

import 'package:demo/model/weather_call_days.dart';
import 'package:demo/utils/forecast_util.dart';
import 'package:flutter/material.dart';

Widget forecastCard(List<WeatherCallDaysList> list, int index) {
  var forecastList = list;
  var dayOfWeek = '';
  DateTime date =
      DateTime.fromMillisecondsSinceEpoch(forecastList[index].dt! * 1000);
  var fullDate = Util.getFormattedDate(date, Platform.localeName);
  dayOfWeek = fullDate.split(',')[0];
  var tempMin = forecastList[index].main!.tempMin!.toStringAsFixed(0);
  var icon = forecastList[index].weather![0]!.getIconUrl();
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            dayOfWeek,
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$tempMin °C',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                  Image.network(icon, scale: 1.2),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
