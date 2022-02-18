import 'package:demo/model/weather_call_days.dart';
import 'package:demo/utils/forecast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExtraDetailDays extends StatelessWidget {
  final List<WeatherCallDaysList?>? list;
  ExtraDetailDays({required this.list});

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Container(
          child: Text(
            list?.length == 0 ? "" : t!.weatherNearFuture,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Container(
          width: double.infinity,
          height: 128,
          child: ListView.builder(
              itemCount: list?.length ?? 0,
              scrollDirection: Axis.horizontal,
              itemExtent: (MediaQuery.of(context).size.width / 2) - 32,
              itemBuilder: (context, index) {
                var time = list?[index]?.dt != null
                    ? Util.getFormattedHHmm(DateTime.fromMillisecondsSinceEpoch(
                            list![index]!.dt! * 1000))
                        .toString()
                    : null;
                return Card(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: _ExtraDetailItem(
                        value:
                            list?[index]?.main?.temp?.toStringAsFixed(0) ?? "",
                        title: list?[index]?.weather?[0]?.description ?? "",
                        icon: list?[index]?.weather?[0]?.getIconUrl() ?? "",
                        time: time),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class _ExtraDetailItem extends StatelessWidget {
  final String value;
  final String title;
  final String icon;
  final String? time;

  _ExtraDetailItem(
      {Key? key,
      required this.value,
      this.time,
      required this.title,
      required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(icon, scale: 1.2),
        SizedBox(width: 10),
        FittedBox(
          fit: BoxFit.cover,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value °C',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              SizedBox(height: 4),
              Container(
                width: 60,
                child: Text(title,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left),
              ),
              SizedBox(height: 4),
              _showTime(time)
            ],
          ),
        ),
      ],
    );
  }
}

Widget _showTime(String? time) {
  return time != null
      ? Text('в ${time.toString()}',
          style: const TextStyle(fontSize: 12, color: Colors.white))
      : SizedBox();
}
