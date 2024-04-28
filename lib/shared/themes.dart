import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

const defaultColor = Colors.purple;
// const Color  defaultSeconderyColor = Colors.purple.shade200;

ThemeData darkTheme = ThemeData(
  fontFamily: 'Whisper',
  primarySwatch: defaultColor,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: defaultColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.purple.shade200,
    unselectedItemColor: Colors.white,
    elevation: 20.0,
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    // backgroundColor: Colors.red,
  ),
  scaffoldBackgroundColor: Colors.purple, //HexColor('333739'),
  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    // backwardsCompatibility: false,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.white10,
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: HexColor('333739'),
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);

//light theme
ThemeData lightTheme = ThemeData(
  fontFamily: 'ElMessiri',
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Whisper',
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
    // bodyText1: TextStyle(
    //   fontSize: 18.0,
    //   fontWeight: FontWeight.w600,
    //   color: Colors.white,
    // ),
  ),
  primarySwatch: defaultColor,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: defaultColor,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: defaultColor,
    elevation: 20.0,
    type: BottomNavigationBarType.fixed,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Colors.purple,
    titleSpacing: 20.0,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    // backwardsCompatibility: false,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.white10,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    elevation: 0,
  ),
);
