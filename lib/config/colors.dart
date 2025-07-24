import 'package:flutter/material.dart';

class AppColors {
  // Primary and secondary colors
  static const Color primary = Color(0xFF2D9B69);
  static const Color primaryVariant = Color(0xFF2E855C);
  static const Color secondary = Color(0xFFE97070);
  static const Color secondaryVariant = Color(0xFFC43B3B);
  // Neutral colors
  static const Color background = Color(0xFFDFEEE9);
  static const Color surface = Color(0xFFFFFFFF);
  // Button colors
  static const Color button1light = Color(0xFF5EBC6E);
  static const Color button1dark = Color(0xFF1DB865);
  static const Color button2 = Color(0xFFF26A23);
  // Text colors
  static const Color textDarkBlue = Color(0xFF111827);
  static const Color textGrey = Color.fromARGB(255, 126, 126, 126);
  // Component colors
  static const Color yellowStar = Color(0xFFEABC05);
  static const Color navbarIcon = Color(0xFFD5E4DF); 

  // Gradient colors
  static const buttonGradient = LinearGradient(
      colors: [AppColors.button1dark, AppColors.button1light],
    );

  static const primaryGradient = const LinearGradient(
      colors: [AppColors.primary, AppColors.primaryVariant],
    );

  static const secondaryGradient = const LinearGradient(
      colors: [AppColors.secondary, AppColors.secondaryVariant],
    );
}
