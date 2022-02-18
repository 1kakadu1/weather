import 'dart:io';

import 'package:demo/model/weather_call_days.dart';
import 'package:demo/utils/forecast_util.dart';
import 'package:demo/widgets/detail_view.dart';
import 'package:demo/widgets/extra_detail_days.dart';
import 'package:flutter/material.dart';
import 'city_detail.dart';
import 'temperature_detail.dart';

class CurrentInfo extends StatelessWidget {
  final WeatherCallDaysCity? city;
  final List<WeatherCallDaysList?>? daysList;
  const CurrentInfo({
    this.city,
    this.daysList,
  });

  List<WeatherCallDaysList?> _getCurrentInfo(List<WeatherCallDaysList?>? list) {
    List<WeatherCallDaysList?> newList = [];
    final List<String> currentDate =
        list?[0]?.dtTxt.toString().split(" ") ?? ["unset", "unset"];

    for (var i = 1; i < list!.length; i++) {
      final List<String> dateItem = list[i]?.dtTxt.toString().split(" ") ??
          ["unset_date_item", "unset_date_item"];

      if (currentDate[0] == dateItem[0] && list[i] != null) {
        newList.add(list[i]);
      } else {
        break;
      }
    }
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    final WeatherCallDaysList? currentInfo = daysList?[0];
    final List<WeatherCallDaysList?>? listTempCurrentDay =
        _getCurrentInfo(daysList);
    return Container(
      padding: EdgeInsets.all(6.0),
      child: Column(children: [
        SizedBox(
          height: 12,
        ),
        _cityDetail(city, currentInfo),
        SizedBox(
          height: 12,
        ),
        TemperatureDetail(weather: currentInfo),
        SizedBox(
          height: 12,
        ),
        DetailView(
          snapshot: daysList,
        ),
        listTempCurrentDay?.length == 0
            ? SizedBox()
            : ExtraDetailDays(list: listTempCurrentDay)
      ]),
    );
  }
}

Widget _cityDetail(
    WeatherCallDaysCity? city, WeatherCallDaysList? currentInfo) {
  DateTime data = currentInfo != null && currentInfo.dt != null
      ? DateTime.fromMillisecondsSinceEpoch(currentInfo.dt! * 1000)
      : DateTime.now();
  final String defaultLocale = Platform.localeName;
  return city != null && currentInfo != null
      ? CityDetail(
          city: city.name.toString() + "," + city.country.toString(),
          date: Util.getFormattedDate(data, defaultLocale).toString(),
        )
      : Text("Error");
}
