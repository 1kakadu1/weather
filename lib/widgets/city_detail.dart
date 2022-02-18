import 'package:flutter/material.dart';

class CityDetail extends StatelessWidget {
  final String city;
  final String date;
  const CityDetail({required this.city, required this.date});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(city,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 26)),
      SizedBox(
        height: 12,
      ),
      Text(date,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16))
    ]);
  }
}
