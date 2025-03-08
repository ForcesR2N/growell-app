import 'package:flutter/material.dart';
import 'package:growell_app/models/food_nutrition_model.dart';
import 'package:intl/intl.dart';

/// Styles constants for consistent UI
class AppStyles {
  // Colors
  static const Color primaryColor = Color(0xFF91C788);
  static const Color secondaryColor = Color(0xFFEEF6ED);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color infoColor = Color(0xFF2196F3);
  
  // Text styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontFamily: 'Signika',
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontFamily: 'Signika',
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Signika',
    color: Colors.black87,
  );
  
  static TextStyle hintStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Signika',
    color: Colors.grey[600],
  );
  
  // Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  static BorderRadius defaultRadius = BorderRadius.circular(12);
}