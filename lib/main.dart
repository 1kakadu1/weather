import 'dart:io';
import 'dart:ui';

import 'package:demo/provider/city.provider.dart';
import 'package:demo/screens/city.dart';
import 'package:demo/screens/home.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _enablePlatformOverrideForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CityProvider()),
      ],
      child: ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        themes: [
          AppTheme(
            id: "custom_dark_theme",
            description: "My Custom Theme dark",
            data: ThemeData.dark().copyWith(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xff121212),
              appBarTheme:
                  AppBarTheme(backgroundColor: const Color(0xff121212)),
            ),
          ),
          AppTheme(
            id: "custom_light_theme",
            description: "My Custom Theme light",
            data: ThemeData.light().copyWith(
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFFFFFFF),
            ),
          ),
        ],
        child: ThemeConsumer(
          child: Builder(
            builder: (themeContext) => MaterialApp(
              theme: ThemeProvider.themeOf(themeContext).data,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', ''),
                const Locale('ru', ''),
              ],
              routes: {
                '/': (context) => HomeScreen(),
                '/city': (context) => CityScreen(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
