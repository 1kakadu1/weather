import 'package:demo/model/weather_call_days.dart';
import 'package:flutter/material.dart';

class TemperatureDetail extends StatelessWidget {
  final WeatherCallDaysList? weather;
  const TemperatureDetail({required this.weather});
  @override
  Widget build(BuildContext context) {
    String desc = weather!.weather![0]!.description.toString();
    String temp = weather!.main!.temp!.toStringAsFixed(0);
    var icon = weather!.weather![0]!.getIconUrl();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Image.network(icon, scale: 0.7)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$temp °C',
                style: const TextStyle(fontSize: 40),
              ),
              SizedBox(height: 10),
              Text(
                '${desc[0].toUpperCase()}${desc.substring(1)}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        )
      ],
    );
  }
}
