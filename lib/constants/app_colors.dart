import 'package:flutter/material.dart';

class AppColors {
  // Primary Gradient
  static const Color gradientStart = Color(0xFF082257); // Bottom (0%)
  static const Color gradientEnd = Color(0xFF0B0024);   // Top (100%)

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [gradientStart, gradientEnd],
  );

  // Accent Colors (matching screenshots)
  static const Color primaryPurple = Color(0xFF4F12F2); // The "Next" button color
  static const Color accentPurple = Color(0xFF6C63FF); // Toggle switch color

  // Text Colors
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  
  // UI Elements
  static const Color inputBackground = Color(0xFF1E1B3A); // Dark input background
  static const Color cardBackground = Color(0xFF1A1736);  // Alarm card bg
}
