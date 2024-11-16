import 'package:flutter/material.dart';
import 'colors.dart'; // Import colors to use in text styles

class AppTextStyles {
  static const TextStyle mainHeading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor, // Reuse colors from AppColors
  );

  static const TextStyle mediumHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static const TextStyle smallText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textColor,
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
  );


// Add more styles as needed
}
