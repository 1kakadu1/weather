# Weather forecast

Small app for weather forecast

## Getting Started

- Install flutter and set up a development environment.
- Get api key on site [openweathermap](https://-openweathermap.org/api)
- Create env.dart file in lib / const folder
```
class Env {
  static const String WEATHER_APP_ID = 'YOU_KEY_API';
  static const String WEATHER_BASE_SCHEME = 'https://';
  static const String WEATHER_BASE_URL_DOMAIN = 'api.openweathermap.org';
  static const String WEATHER_FORECAST_PATH = '/data/2.5/forecast';
  static const String WEATHER_IMAGES_PATH = '/img/w/';
  static const String WEATHER_IMAGES_URL =
      WEATHER_BASE_SCHEME + WEATHER_BASE_URL_DOMAIN + WEATHER_IMAGES_PATH;
}
```
- Replace 'YOU_KEY_API' with the received key

## Checking work
Proposition works on android 7, but has not been tested on ios

## Used libraries
- flutter_launcher_icons
- flutter_native_splash
- flutter_localizations
- http
- flutter_spinkit
- intl
- font_awesome_flutter
- geolocator
- sqflite
- cupertino_icons
- connectivity
- shared_preferences
- theme_provider
- provider
- path_provider

