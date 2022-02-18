import 'package:demo/utils/forecast_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:demo/model/weather_call_days.dart';

class DetailView extends StatelessWidget {
  final List<WeatherCallDaysList?>? snapshot;
  const DetailView({this.snapshot});

  @override
  Widget build(BuildContext context) {
    var pressure = snapshot?[0]?.main?.pressure ?? 0;
    var humidity = snapshot?[0]?.main?.humidity ?? 0;
    var wind = snapshot?[0]?.wind?.speed ?? 0;
    return Container(
      child: snapshot == null
          ? SizedBox()
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Util.getItem(FontAwesomeIcons.thermometerThreeQuarters,
                    (pressure * 0.750062).round(), 'mm Hg'),
                Util.getItem(FontAwesomeIcons.cloudRain, humidity, '%'),
                Util.getItem(FontAwesomeIcons.wind, wind.toInt(), 'm/s'),
              ],
            ),
    );
  }
}
