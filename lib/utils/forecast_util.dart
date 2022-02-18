import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Util {
  static String getFormattedDate(DateTime dateTime, String? lang) {
    initializeDateFormatting();
    return DateFormat('EEE, MMM d, y', lang ?? 'en_US').format(dateTime);
  }

  static String getFormattedDateFormat(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  static String getFormattedHHmm(DateTime dateTime) {
    final int hh = int.parse(DateFormat('H').format(dateTime).toString());
    final int mm = int.parse(DateFormat('m').format(dateTime).toString());
    final String hhFormat = hh < 10 ? '0$hh' : hh.toString();
    final String mmFormat = mm < 10 ? '0$mm' : mm.toString();
    return '$hhFormat:$mmFormat';
  }

  static DateTime toDateTime(int date) {
    return DateTime.fromMillisecondsSinceEpoch(date * 1000);
  }

  static getItem(IconData iconData, int value, String units) {
    return Column(
      children: <Widget>[
        Icon(iconData, size: 28.0),
        SizedBox(height: 10.0),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          '$units',
          style: TextStyle(fontSize: 15.0),
        ),
      ],
    );
  }
}
