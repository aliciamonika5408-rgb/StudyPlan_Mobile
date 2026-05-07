import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Cute Purple 💜
  static const Color primary = Color(0xFF9B72CF);
  static const Color primaryLight = Color(0xFFB794E0);
  static const Color primaryDark = Color(0xFF7B5BAF);

  // Accent - Cute Pink 💗
  static const Color accent = Color(0xFFFF85A2);
  static const Color accentLight = Color(0xFFFFB3C6);

  // Priority Colors - Kawaii palette
  static const Color urgent = Color(0xFFFF6B8A);
  static const Color sedang = Color(0xFFFFB347);
  static const Color rendah = Color(0xFF7EC8E3);

  // Status
  static const Color completed = Color(0xFF5CD6A0);
  static const Color pending = Color(0xFFFF85A2);

  // Background - Soft lavender
  static const Color background = Color(0xFFF8F5FF);
  static const Color cardBackground = Colors.white;
  static const Color surfaceLight = Color(0xFFFCF0F5);

  // Text
  static const Color textPrimary = Color(0xFF3D3255);
  static const Color textSecondary = Color(0xFF9E95B7);
  static const Color textWhite = Colors.white;

  // Gradient - Purple to Pink 💜💗
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB794E0), Color(0xFF9B72CF), Color(0xFFFF85A2)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFB794E0), Color(0xFF9B72CF), Color(0xFF7B5BAF)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB794E0), Color(0xFF9B72CF), Color(0xFFFF85A2)],
  );

  // Cute card gradients
  static const LinearGradient cuteCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFF0F5), Color(0xFFF3E8FF)],
  );
}
