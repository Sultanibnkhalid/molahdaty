import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const defaultColor = Colors.cyan;

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: defaultColor,
    brightness: Brightness.light,
  ),
  fontFamily: 'ElMessiri',
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'ElMessiri', // Fixed typo
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF00363D),
    ),
    displayMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Color(0xFF00363D),
    ),
    displaySmall: TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.normal,
      color: Color(0xFF00363D),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.cyan,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.cyanAccent,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    elevation: 20.0,
  ),
  appBarTheme: const AppBarTheme(
    titleSpacing: 10.0,
    iconTheme: IconThemeData(
      color: Color(0xFF00363D),
    ),
    titleTextStyle: TextStyle(
      color: Color(0xFF00363D),
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'ElMessiri',
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white10,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.cyan,
    elevation: 0,
  ),
);
