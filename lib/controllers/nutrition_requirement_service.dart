// lib/controllers/nutrition_requirement_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:growell_app/models/food_nutrition_model.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class NutritionRequirementService {
  static double calculateCalories(
      int ageInMonths, double weightInKg, double activityLevel) {
    double baseCalories;

    if (ageInMonths <= 3) {
      baseCalories = weightInKg * 108.0;
    } else if (ageInMonths <= 6) {
      baseCalories = weightInKg * 98.0;
    } else if (ageInMonths <= 9) {
      baseCalories = weightInKg * 83.0;
    } else if (ageInMonths <= 12) {
      baseCalories = weightInKg * 80.0;
    } else {
      baseCalories = weightInKg * 75.0;
    }

    double activityFactor = 0.8 + (activityLevel / 10) * 0.4;
    return baseCalories * activityFactor;
  }

  static double calculateProtein(int ageInMonths, double weightInKg) {
    if (ageInMonths <= 6) {
      return weightInKg * 1.52;
    } else if (ageInMonths <= 12) {
      return weightInKg * 1.5;
    } else {
      return weightInKg * 1.1;
    }
  }

  static double calculateCarbs(double calories) {
    return (calories * 0.55) / 4;
  }

  static double calculateFat(double calories, int ageInMonths) {
    double fatPercentage;

    if (ageInMonths <= 6) {
      fatPercentage = 0.45;
    } else if (ageInMonths <= 12) {
      fatPercentage = 0.38;
    } else {
      fatPercentage = 0.33;
    }

    return (calories * fatPercentage) / 9;
  }

  static double calculateIron(int ageInMonths) {
    if (ageInMonths <= 6) {
      return 0.27;
    } else if (ageInMonths <= 12) {
      return 11.0;
    } else {
      return 7.0;
    }
  }

  static double calculateCalcium(int ageInMonths) {
    if (ageInMonths <= 6) {
      return 200.0;
    } else if (ageInMonths <= 12) {
      return 260.0;
    } else {
      return 700.0;
    }
  }

  static double calculateVitaminD(int ageInMonths) {
    return 10.0;
  }

  static double calculateZinc(int ageInMonths) {
    if (ageInMonths <= 6) {
      return 2.0;
    } else if (ageInMonths <= 12) {
      return 3.0;
    } else {
      return 3.0;
    }
  }

  static Map<String, double> getCompleteRequirements(
      int ageInMonths, double weightInKg, double activityLevel) {
    double calories = calculateCalories(ageInMonths, weightInKg, activityLevel);

    return {
      'calories': calories,
      'protein': calculateProtein(ageInMonths, weightInKg),
      'carbs': calculateCarbs(calories),
      'fat': calculateFat(calories, ageInMonths),
      'iron': calculateIron(ageInMonths),
      'calcium': calculateCalcium(ageInMonths),
      'vitaminD': calculateVitaminD(ageInMonths),
      'zinc': calculateZinc(ageInMonths),
    };
  }
}

