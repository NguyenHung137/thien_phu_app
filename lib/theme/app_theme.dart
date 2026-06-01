import 'package:flutter/material.dart';

class AppTheme {
  // Màu sắc chính từ trang web Thiên Phú
  static const Color primaryColor = Color(0xFF446084);    // Xanh navy
  static const Color secondaryColor = Color(0xFFC05530);  // Cam đỏ
  static const Color accentColor = Color(0xFF627D47);     // Xanh lá
  static const Color darkColor = Color(0xFF1A2A3A);       // Đậm
  static const Color lightBg = Color(0xFFF8F9FB);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Gradient chính
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A5F), Color(0xFF446084), Color(0xFF5B7FA6)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0xCC000000)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF446084), Color(0xFF334862)],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: lightBg,
    );
  }
}
