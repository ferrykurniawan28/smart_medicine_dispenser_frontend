import 'package:flutter/material.dart';

abstract class BrightnessMode {
  static const Color primary = Color.fromARGB(255, 189, 224, 254);
  static const Color secondary = Color.fromARGB(255, 255, 200, 221);
  static const Color tertiary1 = Color.fromARGB(255, 162, 210, 255);
  static const Color tertiary2 = Color.fromARGB(255, 255, 175, 204);
  static const Color tertiary3 = Color.fromARGB(255, 205, 180, 219);
}

abstract class DarkMode {
  static const Color primary = Color(0xFF6B847F);
  static const Color secondary = Color(0xFFD9D9D9);
  static const Color tertiary = Color(0xFFE5E5E5);
}
