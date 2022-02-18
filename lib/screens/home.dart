import 'dart:async';

import 'package:demo/const/global_param.dart';
import 'package:demo/model/weather_call_days.dart';
import 'package:demo/provider/city.provider.dart';
import 'package:demo/widgets/bottom_list_view.dart';
import 'package:demo/widgets/current_info.dart';

import 'package:connectivity/connectivity.dart';
import 'package:demo/widgets/switch-theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);
        _loadCity();
      });
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    var _state = Provider.of<CityProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(t!.homeTitle),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async =>
                {await Navigator.pushNamed(context, "/city")},
          ),
          actions: [SwithTheme()],
        ),
        body: _connectionStatus == 'ConnectivityResult.none'
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/no-internet.png'),
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(height: 12),
                    Text(t.internetError),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 28.0),
                child: FutureBuilder(
                    future: _state.futureWeather,
                    builder:
                        (context, AsyncSnapshot<WeatherCallDays> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 18,
                            ),
                            CurrentInfo(
                                city: _state.weather.city,
                                daysList: snapshot.data!.list),
                            SizedBox(
                              height: 20,
                            ),
                            BottomListView(
                              weather: snapshot.data!.list,
                            )
                          ],
                        );
                      }

                      if (snapshot.hasError) {
                        return Text(_state.error);
                      }

                      return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Center(
                          child: SpinKitFoldingCube(
                            color: ThemeProvider.themeOf(context).id ==
                                    "custom_dark_theme"
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            size: 50.0,
                          ),
                        ),
                      );
                    })));
  }

//!TODO: add to provider
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        if (_connectionStatus == 'ConnectivityResult.none' ||
            _connectionStatus == 'Unknown') {
          Provider.of<CityProvider>(context, listen: false)
              .fetchWeatherForecast(city: _loadCity());
        }
        setState(() => {
              _connectionStatus = result.toString(),
            });

        break;
      case ConnectivityResult.none:
        setState(
          () => _connectionStatus = result.toString(),
        );
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  String _loadCity() {
    return this._prefs.getString(GlobalParam.SHARED_KEY_CITY) ??
        Provider.of<CityProvider>(context, listen: false).city;
  }
}
