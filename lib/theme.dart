import 'package:flutter/material.dart';
import 'package:get/get.dart';

ThemeData _darkTheme = ThemeData(
    accentColor: Colors.red,
    brightness: Brightness.dark,
    primaryColor: Colors.amber,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.amber,
      disabledColor: Colors.grey,
    ));

ThemeData _lightTheme = ThemeData(
  accentColor: Colors.blueAccent,
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    disabledColor: Colors.grey,
  ),
);
