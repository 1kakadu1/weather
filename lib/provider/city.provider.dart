import 'dart:io';

import 'package:demo/api/weather_api.dart';
import 'package:demo/const/global_param.dart';
import 'package:demo/model/weather_call_days.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class CityProvider with ChangeNotifier, DiagnosticableTreeMixin {
  String _city = GlobalParam.DEFAULT_CITY;
  String _search = "";
  bool _isFetch = true;
  bool _isSearch = true;
  String _error = "";
  WeatherCallDays _weather = WeatherCallDays(
      cod: null, message: null, cnt: null, list: [], city: null);
  Future<WeatherCallDays>? _futureWeather;

  String get city => _city;
  String get error => _error;
  String get search => _search;
  bool get isFetch => _isFetch;
  bool get isSearch => _isSearch;
  WeatherCallDays get weather => _weather;
  Future<WeatherCallDays>? get futureWeather => _futureWeather;

  void changeCity(String cityName) {
    _city = cityName;
    notifyListeners();
  }

  void changeFeatch(bool val) {
    _isFetch = val;
    notifyListeners();
  }

  void changeSeaech(bool val) {
    _isSearch = val;
    notifyListeners();
  }

  Future<WeatherCallDaysCity?> fetchWeatherForecastGetCity(
      {String? city, bool? isLocation}) async {
    final String defaultLocale = Platform.localeName;
    changeSeaech(true);
    try {
      var response = await WeatherApi().fetchWeatherForecast(
          city: city, lang: defaultLocale, isLocation: isLocation);
      changeSeaech(false);
      return response.city;
    } catch (e) {
      changeSeaech(false);
      log("Error: ${e.toString()}. Status: ${e.hashCode}");
      return throw ("error");
    }
  }

  Future<void> fetchWeatherForecast({String? city}) async {
    final String defaultLocale = Platform.localeName;
    try {
      var response = await WeatherApi()
          .fetchWeatherForecast(city: city ?? _city, lang: defaultLocale);
      _weather = response;
      _futureWeather =
          Future.delayed(const Duration(seconds: 0), () => response);
      _error = "";
    } catch (e) {
      _error = "Error: ${e.toString()}. Status: ${e.hashCode}";
    }
    _isFetch = false;
    notifyListeners();
  }
}
