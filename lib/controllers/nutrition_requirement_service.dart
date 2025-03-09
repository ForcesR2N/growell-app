import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:growell_app/models/food_nutrition_model.dart';
import 'package:intl/intl.dart';
import 'dart:convert';


class NutritionRequirementService {
  /// WHO and AAP based nutrition requirements

  /// Calculate daily calorie requirements based on weight, age, and activity level
  static double calculateCalories(
      int ageInMonths, double weightInKg, double activityLevel) {
    // Base caloric needs by age group
    double baseCalories;

    if (ageInMonths <= 3) {
      // 0-3 months: ~108 kcal/kg/day
      baseCalories = weightInKg * 108.0;
    } else if (ageInMonths <= 6) {
      // 4-6 months: ~98 kcal/kg/day
      baseCalories = weightInKg * 98.0;
    } else if (ageInMonths <= 9) {
      // 7-9 months: ~83 kcal/kg/day
      baseCalories = weightInKg * 83.0;
    } else if (ageInMonths <= 12) {
      // 10-12 months: ~80 kcal/kg/day
      baseCalories = weightInKg * 80.0;
    } else {
      // 13-24 months: ~75 kcal/kg/day
      baseCalories = weightInKg * 75.0;
    }

    // Adjust for activity level (activity factor ranges from 0.8 for low to 1.2 for high)
    double activityFactor = 0.8 + (activityLevel / 10) * 0.4;

    // Return calculated calories adjusted for activity level
    return baseCalories * activityFactor;
  }

  /// Calculate protein requirements based on weight and age
  static double calculateProtein(int ageInMonths, double weightInKg) {
    // Protein requirements in g/kg/day
    if (ageInMonths <= 6) {
      // 0-6 months: 1.52 g/kg/day
      return weightInKg * 1.52;
    } else if (ageInMonths <= 12) {
      // 7-12 months: 1.5 g/kg/day
      return weightInKg * 1.5;
    } else {
      // 13-24 months: 1.1 g/kg/day
      return weightInKg * 1.1;
    }
  }

  /// Calculate carbohydrate requirements based on total calories
  static double calculateCarbs(double calories) {
    // Carbs should be 45-65% of total calories
    // 1g of carbs = 4 calories
    // Using average of 55% of calories from carbs
    return (calories * 0.55) / 4;
  }

  /// Calculate fat requirements based on total calories and age
  static double calculateFat(double calories, int ageInMonths) {
    double fatPercentage;

    if (ageInMonths <= 6) {
      // 0-6 months: 40-50% of calories from fat
      fatPercentage = 0.45; // Using 45%
    } else if (ageInMonths <= 12) {
      // 7-12 months: 35-40% of calories from fat
      fatPercentage = 0.38; // Using 38%
    } else {
      // 13-24 months: 30-35% of calories from fat
      fatPercentage = 0.33; // Using 33%
    }

    // 1g of fat = 9 calories
    return (calories * fatPercentage) / 9;
  }

  /// Calculate iron requirements based on age
  static double calculateIron(int ageInMonths) {
    if (ageInMonths <= 6) {
      // 0-6 months: 0.27 mg/day
      return 0.27;
    } else if (ageInMonths <= 12) {
      // 7-12 months: 11 mg/day
      return 11.0;
    } else {
      // 13-24 months: a mg/day
      return 7.0;
    }
  }

  /// Calculate calcium requirements based on age
  static double calculateCalcium(int ageInMonths) {
    if (ageInMonths <= 6) {
      // 0-6 months: 200 mg/day
      return 200.0;
    } else if (ageInMonths <= 12) {
      // 7-12 months: 260 mg/day
      return 260.0;
    } else {
      // 13-24 months: 700 mg/day
      return 700.0;
    }
  }

  /// Calculate vitamin D requirements based on age
  static double calculateVitaminD(int ageInMonths) {
    // Vitamin D is typically 400 IU (10 mcg) for all infants 0-24 months
    return 10.0; // in mcg
  }

  /// Calculate zinc requirements based on age
  static double calculateZinc(int ageInMonths) {
    if (ageInMonths <= 6) {
      // 0-6 months: 2 mg/day
      return 2.0;
    } else if (ageInMonths <= 12) {
      // A-M months: 3 mg/day
      return 3.0;
    } else {
      // 13-24 months: 3 mg/day
      return 3.0;
    }
  }

  /// Get complete nutrition requirements
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

// Enhancement of DailyNutritionController
class DailyNutritionController extends GetxController {
  // Target nutrisi harian
  final targetCalories = 0.0.obs;
  final targetProtein = 0.0.obs;
  final targetCarbs = 0.0.obs;
  final targetFat = 0.0.obs;

  // New micronutrients tracking
  final targetIron = 0.0.obs;
  final targetCalcium = 0.0.obs;
  final targetVitaminD = 0.0.obs;
  final targetZinc = 0.0.obs;

  // Consumed micronutrients
  final consumedIron = 0.0.obs;
  final consumedCalcium = 0.0.obs;
  final consumedVitaminD = 0.0.obs;
  final consumedZinc = 0.0.obs;

  // Existing properties...
  final consumedCalories = 0.0.obs;
  final consumedProtein = 0.0.obs;
  final consumedCarbs = 0.0.obs;
  final consumedFat = 0.0.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final ageError = RxString('');
  final weightError = RxString('');
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final consumedFoods = <FoodNutrition>[].obs;
  final weightStatus = RxString('');
  final idealWeightLow = 0.0.obs;
  final idealWeightHigh = 0.0.obs;
  final currentDate = DateTime.now().obs;
  final dateFormatted = RxString('');

  // Added: Baby activity level from profile (default to medium)
  final activityLevel = 5.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Format tanggal
    dateFormatted.value = DateFormat('dd MMMM yyyy').format(currentDate.value);

    // Load data dari shared preferences
    loadSavedData();

    // Load activity level from baby profile
    loadActivityLevel();
  }

  // New method to load the baby's activity level
  Future<void> loadActivityLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double savedLevel = prefs.getDouble('babyActivityLevel') ?? 5.0;
      activityLevel.value = savedLevel;
    } catch (e) {
      print('Error loading activity level: $e');
    }
  }

  void calculateWeightStatus(int ageInMonths, double weightInKg) {
    // Data WHO weight-for-age untuk anak (digunakan sebagai estimasi umum)
    // Format: [usia dalam bulan, berat minimal (kg), berat maksimal (kg)]
    final weightChartData = [
      [0, 2.9, 4.4], // lahir
      [1, 3.9, 5.8], // 1 bulan
      [2, 4.9, 7.1], // 2 bulan
      [3, 5.7, 8.0], // 3 bulan
      [4, 6.2, 8.7], // 4 bulan
      [5, 6.7, 9.3], // 5 bulan
      [6, 7.1, 9.8], // 6 bulan
      [7, 7.4, 10.3], // 7 bulan
      [8, 7.7, 10.7], // 8 bulan
      [9, 8.0, 11.0], // 9 bulan
      [10, 8.2, 11.4], // 10 bulan
      [11, 8.4, 11.7], // 11 bulan
      [12, 8.6, 12.0], // 12 bulan
      [15, 9.2, 12.8], // 15 bulan
      [18, 9.8, 13.6], // 18 bulan
      [21, 10.3, 14.3], // 21 bulan
      [24, 10.8, 15.0], // 24 bulan
    ];

    // Cari data berat yang paling sesuai dengan usia
    var idealWeight = weightChartData.firstWhere(
      (data) => data[0] == ageInMonths,
      orElse: () {
        // Jika tidak ada yang persis, ambil yang terdekat
        if (ageInMonths > 24) {
          return weightChartData.last; // gunakan data untuk 24 bulan
        } else {
          // Interpolasi linear untuk mendapatkan estimasi
          for (int i = 0; i < weightChartData.length - 1; i++) {
            if (ageInMonths > weightChartData[i][0] &&
                ageInMonths < weightChartData[i + 1][0]) {
              final lowerAge = weightChartData[i][0];
              final upperAge = weightChartData[i + 1][0];
              final ratio = (ageInMonths - lowerAge) / (upperAge - lowerAge);

              final lowerMin = weightChartData[i][1];
              final upperMin = weightChartData[i + 1][1];
              final lowerMax = weightChartData[i][2];
              final upperMax = weightChartData[i + 1][2];

              final interpolatedMin = lowerMin + (upperMin - lowerMin) * ratio;
              final interpolatedMax = lowerMax + (upperMax - lowerMax) * ratio;

              return [ageInMonths, interpolatedMin, interpolatedMax];
            }
          }
          return weightChartData
              .first; // default ke 0 bulan jika tidak ditemukan
        }
      },
    );

    // Set berat ideal
    idealWeightLow.value = idealWeight[1].toDouble();
    idealWeightHigh.value = idealWeight[2].toDouble();

    // Tentukan status berat badan
    if (weightInKg < idealWeight[1]) {
      weightStatus.value = 'underweight';
    } else if (weightInKg > idealWeight[2]) {
      weightStatus.value = 'overweight';
    } else {
      weightStatus.value = 'normal';
    }
  }

  // Improved: Calculate requirements based on more accurate WHO standards
  void calculateRequirements(String age, String weight) {
    try {
      isLoading.value = true;

      // Validate input directly instead of calling a separate method
      bool isValid = true;
      ageError.value = '';
      weightError.value = '';

      // Validate age
      int ageInMonths;
      double weightInKg;

      try {
        ageInMonths = int.parse(age);
        if (ageInMonths <= 0 || ageInMonths > 24) {
          ageError.value = 'Usia harus antara 1-24 bulan';
          isValid = false;
        }
      } catch (e) {
        ageError.value = 'Usia tidak valid';
        isValid = false;
        ageInMonths = 0; // Default value to prevent further errors
      }

      // Validate weight
      try {
        weightInKg = double.parse(weight);
        if (weightInKg <= 0 || weightInKg > 30) {
          weightError.value = 'Berat badan tidak valid';
          isValid = false;
        }
      } catch (e) {
        weightError.value = 'Berat badan tidak valid';
        isValid = false;
        weightInKg = 0; // Default value to prevent further errors
      }

      if (!isValid) return;

      // Use the enhanced nutrition service for calculations
      final requirements = NutritionRequirementService.getCompleteRequirements(
          ageInMonths, weightInKg, activityLevel.value);

      // Set macronutrient targets
      targetCalories.value = requirements['calories']!;
      targetProtein.value = requirements['protein']!;
      targetCarbs.value = requirements['carbs']!;
      targetFat.value = requirements['fat']!;

      // Set micronutrient targets
      targetIron.value = requirements['iron']!;
      targetCalcium.value = requirements['calcium']!;
      targetVitaminD.value = requirements['vitaminD']!;
      targetZinc.value = requirements['zinc']!;

      // Calculate ideal weight range
      calculateWeightStatus(ageInMonths, weightInKg);

      // Save data
      saveData();

      // Show success message with nutrition summary
      Get.snackbar(
        'Kebutuhan Nutrisi',
        'Kebutuhan nutrisi harian berhasil dihitung',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menghitung: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Other methods from original controller...

  // Enhanced method to save data including new micronutrients
  Future<void> saveData() async {
    try {
      isSaving.value = true;

      final prefs = await SharedPreferences.getInstance();

      // Save macronutrient targets
      prefs.setDouble('targetCalories', targetCalories.value);
      prefs.setDouble('targetProtein', targetProtein.value);
      prefs.setDouble('targetCarbs', targetCarbs.value);
      prefs.setDouble('targetFat', targetFat.value);

      // Save micronutrient targets
      prefs.setDouble('targetIron', targetIron.value);
      prefs.setDouble('targetCalcium', targetCalcium.value);
      prefs.setDouble('targetVitaminD', targetVitaminD.value);
      prefs.setDouble('targetZinc', targetZinc.value);

      // Save consumed nutrients
      prefs.setDouble('consumedCalories', consumedCalories.value);
      prefs.setDouble('consumedProtein', consumedProtein.value);
      prefs.setDouble('consumedCarbs', consumedCarbs.value);
      prefs.setDouble('consumedFat', consumedFat.value);

      // Save consumed micronutrients
      prefs.setDouble('consumedIron', consumedIron.value);
      prefs.setDouble('consumedCalcium', consumedCalcium.value);
      prefs.setDouble('consumedVitaminD', consumedVitaminD.value);
      prefs.setDouble('consumedZinc', consumedZinc.value);

      // Save date
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      prefs.setString('nutritionDate', today);

      // Save food list
      final foodsJson =
          consumedFoods.map((food) => json.encode(food.toJson())).toList();
      prefs.setStringList('consumedFoods', foodsJson);

      // Save input values
      if (ageController.text.isNotEmpty) {
        prefs.setString('inputAge', ageController.text);
      }

      if (weightController.text.isNotEmpty) {
        prefs.setString('inputWeight', weightController.text);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menyimpan data: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isSaving.value = false;
    }
  }

  // Enhanced loadSavedData to include micronutrients
  Future<void> loadSavedData() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();

      // Load macronutrient targets
      targetCalories.value = prefs.getDouble('targetCalories') ?? 0.0;
      targetProtein.value = prefs.getDouble('targetProtein') ?? 0.0;
      targetCarbs.value = prefs.getDouble('targetCarbs') ?? 0.0;
      targetFat.value = prefs.getDouble('targetFat') ?? 0.0;

      // Load micronutrient targets
      targetIron.value = prefs.getDouble('targetIron') ?? 0.0;
      targetCalcium.value = prefs.getDouble('targetCalcium') ?? 0.0;
      targetVitaminD.value = prefs.getDouble('targetVitaminD') ?? 0.0;
      targetZinc.value = prefs.getDouble('targetZinc') ?? 0.0;

      // Check if the saved data is for today
      final savedDate = prefs.getString('nutritionDate') ?? '';
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (savedDate == today) {
        // Load consumed macronutrients
        consumedCalories.value = prefs.getDouble('consumedCalories') ?? 0.0;
        consumedProtein.value = prefs.getDouble('consumedProtein') ?? 0.0;
        consumedCarbs.value = prefs.getDouble('consumedCarbs') ?? 0.0;
        consumedFat.value = prefs.getDouble('consumedFat') ?? 0.0;

        // Load consumed micronutrients
        consumedIron.value = prefs.getDouble('consumedIron') ?? 0.0;
        consumedCalcium.value = prefs.getDouble('consumedCalcium') ?? 0.0;
        consumedVitaminD.value = prefs.getDouble('consumedVitaminD') ?? 0.0;
        consumedZinc.value = prefs.getDouble('consumedZinc') ?? 0.0;

        // Load food list
        final foodsJson = prefs.getStringList('consumedFoods') ?? [];
        final foods = foodsJson
            .map((item) => FoodNutrition.fromJson(json.decode(item)))
            .toList();
        consumedFoods.assignAll(foods);
      }

      // Load saved input values
      final savedAge = prefs.getString('inputAge') ?? '';
      final savedWeight = prefs.getString('inputWeight') ?? '';

      if (savedAge.isNotEmpty) {
        ageController.text = savedAge;
      }

      if (savedWeight.isNotEmpty) {
        weightController.text = savedWeight;
      }

      // Recalculate weight status if we have all needed data
      if (targetCalories.value > 0 &&
          savedAge.isNotEmpty &&
          savedWeight.isNotEmpty) {
        calculateWeightStatus(int.parse(savedAge), double.parse(savedWeight));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat memuat data: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, double> getNutritionPercentages() {
    if (targetCalories.value == 0)
      return {
        'calories': 0,
        'protein': 0,
        'carbs': 0,
        'fat': 0,
        'iron': 0,
        'calcium': 0,
        'vitaminD': 0,
        'zinc': 0,
      };

    return {
      'calories': (consumedCalories.value / targetCalories.value) * 100,
      'protein': (consumedProtein.value / targetProtein.value) * 100,
      'carbs': (consumedCarbs.value / targetCarbs.value) * 100,
      'fat': (consumedFat.value / targetFat.value) * 100,
      'iron': targetIron.value > 0
          ? (consumedIron.value / targetIron.value) * 100
          : 0,
      'calcium': targetCalcium.value > 0
          ? (consumedCalcium.value / targetCalcium.value) * 100
          : 0,
      'vitaminD': targetVitaminD.value > 0
          ? (consumedVitaminD.value / targetVitaminD.value) * 100
          : 0,
      'zinc': targetZinc.value > 0
          ? (consumedZinc.value / targetZinc.value) * 100
          : 0,
    };
  }
}