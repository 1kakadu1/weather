import 'package:demo/model/weather_call_days.dart';
import 'package:flutter/material.dart';
import 'package:demo/widgets/forecast_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomListView extends StatelessWidget {
  final List<WeatherCallDaysList?>? weather;
  const BottomListView({this.weather});

  List<WeatherCallDaysList> _listDays(List<WeatherCallDaysList?>? daysList) {
    List<WeatherCallDaysList> list = [];
    if (daysList != null && daysList.length > 0) {
      String date = daysList[0]?.dtTxt?.split(" ")[0] ?? "";
      if (date == "" && daysList[0] != null) {
        return list;
      } else {
        list.add(daysList[0] as WeatherCallDaysList);
      }

      for (var i = 1; i < daysList.length; i++) {
        String itemDate = daysList[i]!.dtTxt!.split(" ")[0];
        if (date != itemDate) {
          date = itemDate;
          list.add(daysList[i] as WeatherCallDaysList);
        }
      }
    }
    print('week: $list');
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<WeatherCallDaysList> weekDays = _listDays(weather);
    var t = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          t!.weatherDaysFuture,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 140,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 8),
            itemCount: weekDays.length,
            itemBuilder: (context, index) => Container(
              width: MediaQuery.of(context).size.width / 2.7,
              height: 160,
              child: forecastCard(weekDays, index),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
