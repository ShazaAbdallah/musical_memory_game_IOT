import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFF636363),
  100: Color(0xFFDCEDC8),
  200: Color(0xFFC5E1A5),
  300: Color(0xFFAED581),
  400: Color(0xFF9CCC65),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF83BD43),
  700: Color(0xFF78B53A),
  800: Color(0xFF6EAE32),
  900: Color(0xFF5BA122),
});
const int _primaryPrimaryValue = 0xFF8BC34A;

const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFEBFFDD),
  200: Color(_primaryAccentValue),
  400: Color(0xFFB0FF77),
  700: Color(0xFFA2FF5D),
});
const int _primaryAccentValue = 0xFFCEFFAA;