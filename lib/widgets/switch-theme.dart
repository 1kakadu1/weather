import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:theme_provider/theme_provider.dart';

class SwithTheme extends StatefulWidget {
  SwithTheme({Key? key}) : super(key: key);
  @override
  _SwithTheme createState() => _SwithTheme();
}

class _SwithTheme extends State<SwithTheme> {
  bool isDark = true;
  void onChanged(bool value) {
    setState(() {
      isDark = value;
    });
    ThemeProvider.controllerOf(context).nextTheme();
    //ThemeProvider.controllerOf(context).saveThemeToDisk();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(value: isDark, onChanged: onChanged);
  }
}
