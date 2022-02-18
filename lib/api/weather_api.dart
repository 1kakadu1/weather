import 'dart:convert';
import 'dart:developer';
import 'package:demo/const/env.dart';
import 'package:demo/model/weather_call_days.dart';
import 'package:demo/utils/location.dart';
import 'package:http/http.dart' as http;

class WeatherApi {
  Future<WeatherCallDays> fetchWeatherForecast(
      {String? city, String? lang, bool? isLocation}) async {
    var langFormat = lang?.split("_")[0] ?? 'en';
    Map<String, String> parameters = {
      'appid': Env.WEATHER_APP_ID,
      'units': 'metric',
      'lang': langFormat
    };

    if (isLocation == true) {
      Location location = Location();
      await location.getCurrentLocation();
      log("location ${location.error}");
      if (location.error != "") {
        return Future.error(location.error);
      }
      parameters['lat'] = location.latitude.toString();
      parameters['lon'] = location.longitude.toString();
    } else {
      parameters['q'] = city ?? "";
    }
    var uri = Uri.https(
        Env.WEATHER_BASE_URL_DOMAIN, Env.WEATHER_FORECAST_PATH, parameters);
    log('request: ${uri.toString()}');

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      return WeatherCallDays.fromJson(json.decode(response.body));
    } else {
      return Future.error('Error response');
    }
  }
}
