import 'package:flutter/material.dart';

ThemeData lightTheme(BuildContext context) => ThemeData.light().copyWith(
  // dividerColor: Colors.transparent
);

ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
  // dividerColor: Colors.transparent
);

bool isLightTheme(BuildContext context) {
  return false;
  // return MediaQuery.of(context).platformBrightness == Brightness.light;
}