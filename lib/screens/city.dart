import 'package:demo/const/global_param.dart';
import 'package:demo/db/database.dart';
import 'package:demo/model/city.dart';
import 'package:demo/model/weather_call_days.dart';
import 'package:demo/widgets/search-field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:demo/provider/city.provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityScreen extends StatefulWidget {
  CityScreen({Key? key}) : super(key: key);
  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  WeatherCallDaysCity? searchRezult;
  late SharedPreferences _prefs;
  late Future<List<City>> _cityDBList;
  @override
  void initState() {
    super.initState();
    _updateCityDBList();
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);
      });
  }

  void _onSearch(String text, {bool? isLocation}) {
    CityProvider _state = Provider.of<CityProvider>(context, listen: false);
    var t = AppLocalizations.of(context);
    _state
        .fetchWeatherForecastGetCity(city: text, isLocation: isLocation)
        .then((value) {
      setState(() {
        searchRezult = value;
      });
      ScaffoldMessenger.of(context).showSnackBar(_snackBar(t!.searchCityDone));
    }).catchError((e) {
      setState(() {
        searchRezult = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(_snackBar(t!.searchCityError));
    });
  }

  void _updateCityDBList() {
    setState(() {
      _cityDBList = DBProvider.db.getCity();
    });
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    final String name = searchRezult?.name ?? "";
    bool isDisable = searchRezult == null ? true : false;
    List<Widget> actionAppBar = isDisable
        ? [
            IconButton(
                icon: const Icon(Icons.add_location),
                onPressed: () => _onSearch("", isLocation: true))
          ]
        : [_setDefauilt(name, t)];
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(t!.cityTitle),
          centerTitle: true,
          actions: actionAppBar,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 28.0),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Search(
                      onSubmit: _onSearch,
                      value: name,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: !isDisable ? 1.0 : 0.6,
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: isDisable
                            ? null
                            : () => this._setHomeWeather(searchRezult?.name),
                        child: Text(
                          t.getWeather,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isDisable ? null : _saveDBWeather,
                        child: Text(
                          t.saveCity,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 5.0,
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: _cityDBList,
                  builder: (context, AsyncSnapshot<List<City>> snapshot) {
                    final int len = snapshot.data?.length ?? -1;
                    if (len == 0) {
                      return Text("Ваш список избранного пуст");
                    }
                    if (snapshot.hasData) {
                      return generateList(snapshot.data!, t);
                    }
                    if (snapshot.data == null) {
                      return Text('Error no data found');
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void _setHomeWeather(String? city) {
    CityProvider _state = Provider.of<CityProvider>(context, listen: false);
    if (city != null) {
      _state.changeCity(city);
      _state.fetchWeatherForecast(city: city);

      setState(() {
        searchRezult = null;
      });
    }
  }

  void _saveDBWeather() {
    if (searchRezult != null &&
        searchRezult?.name != null &&
        searchRezult?.coord?.lat != null &&
        searchRezult?.coord?.lon != null) {
      _snackBar("Город успешко добавлин в избранное");
      DBProvider.db.insertCity(City(null, searchRezult!.name!,
          searchRezult!.coord!.lat!, searchRezult!.coord!.lon!));
      this._updateCityDBList();
      setState(() {
        searchRezult = null;
      });
    } else {
      _snackBar("Ошибка данных. Повторите через время");
    }
  }

  Future<Null> _setCityPref(String value) async {
    await this._prefs.setString(GlobalParam.SHARED_KEY_CITY, value);
    Provider.of<CityProvider>(context, listen: false).changeCity(value);
    Provider.of<CityProvider>(context, listen: false)
        .fetchWeatherForecast(city: value);
  }

  Widget _setDefauilt(String city, var t) {
    return IconButton(
      icon: const Icon(Icons.save),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(t!.alertSetDefaultCity),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(t.no),
            ),
            TextButton(
              onPressed: () {
                if (city != "") {
                  this._setCityPref(city);
                  this._setHomeWeather(city);
                }
                Navigator.pop(context, 'OK');
              },
              child: Text(t.yes),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView generateList(List<City> cityList, var t) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          headingRowHeight: 56.0,
          dataRowHeight: 96,
          columns: [
            DataColumn(
              label: Text('Город'),
            ),
            DataColumn(
              label: const Text(''),
            ),
          ],
          rows: cityList
              .map(
                (city) => DataRow(cells: [
                  DataCell(
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            Text(city.name),
                            SizedBox(height: 8),
                            Text(
                              'lon: ${city.lon}',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'lat: ${city.lat}',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      onTap: () {}),
                  DataCell(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        this._setDefauilt(city.name, t),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            DBProvider.db.deleteStudent(city.id as int);
                            this._updateCityDBList();
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              )
              .toList(),
        ),
      ),
    );
  }
}

SnackBar _snackBar(String msg) {
  return SnackBar(
    content: Text(msg),
    duration: const Duration(milliseconds: 2000),
    width: 310.0, // Width of the SnackBar.
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0, // Inner padding for SnackBar content.
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
