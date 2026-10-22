import 'package:flutter/material.dart';

/// MoodNest pastel baby-blue palette.
///
/// Pastel backgrounds use [navy] text. Buttons and icons use the stronger
/// [primary] blue so white text on them stays readable.
class AppColors {
  AppColors._();

  // Pastel fills (headers, tiles, chips)
  static const Color pastelBlue = Color(0xFFBFE3FF);
  static const Color pastelSky = Color(0xFFD6ECFF);
  static const Color pastelAqua = Color(0xFFD3F1FA);
  static const Color pastelPeri = Color(0xFFE2E6FF);
  static const Color pastelMint = Color(0xFFD8F3EC);

  // Header gradient (very soft, top-left to bottom-right)
  static const List<Color> headerGradient = [pastelSky, pastelBlue, pastelAqua];

  // Stronger blues for buttons, icons and accents
  static const Color primary = Color(0xFF4A9FE8);
  static const Color primaryDark = Color(0xFF2F7CC2);
  static const Color aqua = Color(0xFF3AA8CF);

  // Text
  static const Color navy = Color(0xFF0B3B66); // main text on pastel
  static const Color navySoft = Color(0xFF4A6A8A); // secondary text

  // Backgrounds
  static const Color background = Color(0xFFF5FAFF);
  static const Color card = Color(0xFFFFFFFF);
}
