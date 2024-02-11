import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  fontFamily: 'Montserrat',
  brightness: Brightness.light,
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xff534B62),
  ),
  colorScheme: const ColorScheme.light(
      background: Color.fromARGB(255, 196, 235, 250),
      primary: Color(0xff226CE0),
      secondary: Color(0xff1B1725),
      tertiary: Color(0xff304C89)),
);
