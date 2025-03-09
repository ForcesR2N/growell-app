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

class DailyNutritionController extends GetxController {
TextEditingController? ageController;
TextEditingController? weightController;

  final isDisposed = false.obs;

  final targetCalories = 0.0.obs;
  final targetProtein = 0.0.obs;
  final targetCarbs = 0.0.obs;
  final targetFat = 0.0.obs;
  final targetIron = 0.0.obs;
  final targetCalcium = 0.0.obs;
  final targetVitaminD = 0.0.obs;
  final targetZinc = 0.0.obs;

  final consumedCalories = 0.0.obs;
  final consumedProtein = 0.0.obs;
  final consumedCarbs = 0.0.obs;
  final consumedFat = 0.0.obs;
  final consumedIron = 0.0.obs;
  final consumedCalcium = 0.0.obs;
  final consumedVitaminD = 0.0.obs;
  final consumedZinc = 0.0.obs;

  final isLoading = false.obs;
  final isSaving = false.obs;
  final ageError = RxString('');
  final weightError = RxString('');

  final consumedFoods = <FoodNutrition>[].obs;

  final idealWeightLow = 0.0.obs;
  final idealWeightHigh = 0.0.obs;
  final weightStatus = RxString('');

  final currentDate = DateTime.now().obs;
  final dateFormatted = RxString('');

  final activityLevel = 5.0.obs;

  @override
  void onInit() {
    super.onInit();
    ageController = TextEditingController();
    weightController = TextEditingController();
    dateFormatted.value = DateFormat('dd MMMM yyyy').format(currentDate.value);
    loadSavedData();
    loadActivityLevel();
  }

  @override
  void onClose() {
    isDisposed.value = true;
 try {

    ageController?.dispose();
    weightController?.dispose();
    
    ageController = null;
    weightController = null;
  } catch (e) {
    print('Error disposing controllers: $e');
  }
  super.onClose();
}

  bool get isActive => !isDisposed.value;

  Future<void> loadActivityLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double savedLevel = prefs.getDouble('babyActivityLevel') ?? 5.0;
      activityLevel.value = savedLevel;
    } catch (e) {
      print('Error loading activity level: $e');
    }
  }

  Future<void> loadSavedData() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();

      targetCalories.value = prefs.getDouble('targetCalories') ?? 0.0;
      targetProtein.value = prefs.getDouble('targetProtein') ?? 0.0;
      targetCarbs.value = prefs.getDouble('targetCarbs') ?? 0.0;
      targetFat.value = prefs.getDouble('targetFat') ?? 0.0;

      targetIron.value = prefs.getDouble('targetIron') ?? 0.0;
      targetCalcium.value = prefs.getDouble('targetCalcium') ?? 0.0;
      targetVitaminD.value = prefs.getDouble('targetVitaminD') ?? 0.0;
      targetZinc.value = prefs.getDouble('targetZinc') ?? 0.0;

      final savedDate = prefs.getString('nutritionDate') ?? '';
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (savedDate == today) {
        consumedCalories.value = prefs.getDouble('consumedCalories') ?? 0.0;
        consumedProtein.value = prefs.getDouble('consumedProtein') ?? 0.0;
        consumedCarbs.value = prefs.getDouble('consumedCarbs') ?? 0.0;
        consumedFat.value = prefs.getDouble('consumedFat') ?? 0.0;

        consumedIron.value = prefs.getDouble('consumedIron') ?? 0.0;
        consumedCalcium.value = prefs.getDouble('consumedCalcium') ?? 0.0;
        consumedVitaminD.value = prefs.getDouble('consumedVitaminD') ?? 0.0;
        consumedZinc.value = prefs.getDouble('consumedZinc') ?? 0.0;

        final foodsJson = prefs.getStringList('consumedFoods') ?? [];
        final foods = foodsJson
            .map((item) => FoodNutrition.fromJson(json.decode(item)))
            .toList();
        consumedFoods.assignAll(foods);
      }

      final savedAge = prefs.getString('inputAge') ?? '';
      final savedWeight = prefs.getString('inputWeight') ?? '';

      if (savedAge.isNotEmpty) {
        ageController.text = savedAge;
      }

      if (savedWeight.isNotEmpty) {
        weightController.text = savedWeight;
      }

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

  Future<void> saveData() async {
    try {
      isSaving.value = true;

      final prefs = await SharedPreferences.getInstance();

      prefs.setDouble('targetCalories', targetCalories.value);
      prefs.setDouble('targetProtein', targetProtein.value);
      prefs.setDouble('targetCarbs', targetCarbs.value);
      prefs.setDouble('targetFat', targetFat.value);

      prefs.setDouble('targetIron', targetIron.value);
      prefs.setDouble('targetCalcium', targetCalcium.value);
      prefs.setDouble('targetVitaminD', targetVitaminD.value);
      prefs.setDouble('targetZinc', targetZinc.value);

      prefs.setDouble('consumedCalories', consumedCalories.value);
      prefs.setDouble('consumedProtein', consumedProtein.value);
      prefs.setDouble('consumedCarbs', consumedCarbs.value);
      prefs.setDouble('consumedFat', consumedFat.value);

      prefs.setDouble('consumedIron', consumedIron.value);
      prefs.setDouble('consumedCalcium', consumedCalcium.value);
      prefs.setDouble('consumedVitaminD', consumedVitaminD.value);
      prefs.setDouble('consumedZinc', consumedZinc.value);

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      prefs.setString('nutritionDate', today);

      final foodsJson =
          consumedFoods.map((food) => json.encode(food.toJson())).toList();
      prefs.setStringList('consumedFoods', foodsJson);

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

  void calculateRequirements(String age, String weight) {
    try {
      isLoading.value = true;

      bool isValid = true;
      ageError.value = '';
      weightError.value = '';

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
        ageInMonths = 0;
      }

      try {
        weightInKg = double.parse(weight);
        if (weightInKg <= 0 || weightInKg > 30) {
          weightError.value = 'Berat badan tidak valid';
          isValid = false;
        }
      } catch (e) {
        weightError.value = 'Berat badan tidak valid';
        isValid = false;
        weightInKg = 0;
      }

      if (!isValid) return;

      final requirements = NutritionRequirementService.getCompleteRequirements(
          ageInMonths, weightInKg, activityLevel.value);

      targetCalories.value = requirements['calories']!;
      targetProtein.value = requirements['protein']!;
      targetCarbs.value = requirements['carbs']!;
      targetFat.value = requirements['fat']!;

      targetIron.value = requirements['iron']!;
      targetCalcium.value = requirements['calcium']!;
      targetVitaminD.value = requirements['vitaminD']!;
      targetZinc.value = requirements['zinc']!;

      calculateWeightStatus(ageInMonths, weightInKg);

      saveData();

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

  void calculateWeightStatus(int ageInMonths, double weightInKg) {
    final weightChartData = [
      [0, 2.9, 4.4],
      [1, 3.9, 5.8],
      [2, 4.9, 7.1],
      [3, 5.7, 8.0],
      [4, 6.2, 8.7],
      [5, 6.7, 9.3],
      [6, 7.1, 9.8],
      [7, 7.4, 10.3],
      [8, 7.7, 10.7],
      [9, 8.0, 11.0],
      [10, 8.2, 11.4],
      [11, 8.4, 11.7],
      [12, 8.6, 12.0],
      [15, 9.2, 12.8],
      [18, 9.8, 13.6],
      [21, 10.3, 14.3],
      [24, 10.8, 15.0],
    ];

    var idealWeight = weightChartData.firstWhere(
      (data) => data[0] == ageInMonths,
      orElse: () {
        if (ageInMonths > 24) {
          return weightChartData.last;
        } else {
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
          return weightChartData.first;
        }
      },
    );

    idealWeightLow.value = idealWeight[1].toDouble();
    idealWeightHigh.value = idealWeight[2].toDouble();

    if (weightInKg < idealWeight[1]) {
      weightStatus.value = 'underweight';
    } else if (weightInKg > idealWeight[2]) {
      weightStatus.value = 'overweight';
    } else {
      weightStatus.value = 'normal';
    }
  }

  String getWeightStatusAdvice() {
    if (weightStatus.value == 'underweight') {
      return 'Berat badan si kecil kurang dari ideal. Tambahkan makanan padat gizi dan tinggi kalori seperti alpukat, ikan, dan makanan dengan lemak sehat. Tingkatkan frekuensi makan.';
    } else if (weightStatus.value == 'overweight') {
      return 'Berat badan si kecil lebih dari ideal. Pastikan porsi sesuai dan pilih makanan kaya nutrisi. Hindari makanan tinggi gula dan lemak jenuh. Tetap aktif bermain.';
    } else {
      return 'Berat badan si kecil sudah ideal. Pertahankan pola makan seimbang dan berikan variasi makanan sehat untuk mendukung tumbuh kembangnya.';
    }
  }

  void addFood(FoodNutrition food, double portion) {
    try {
      final adjustedFood = food.adjustPortion(portion);
      consumedFoods.add(adjustedFood);

      consumedCalories.value += adjustedFood.calories;
      consumedProtein.value += adjustedFood.protein;
      consumedCarbs.value += adjustedFood.carbs;
      consumedFat.value += adjustedFood.fat;

      if (adjustedFood.iron != null) consumedIron.value += adjustedFood.iron!;
      if (adjustedFood.calcium != null)
        consumedCalcium.value += adjustedFood.calcium!;
      if (adjustedFood.vitaminD != null)
        consumedVitaminD.value += adjustedFood.vitaminD!;
      if (adjustedFood.zinc != null) consumedZinc.value += adjustedFood.zinc!;

      saveData();

      Get.snackbar(
        'Berhasil',
        'Makanan berhasil ditambahkan',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan makanan: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  void removeFood(int index) {
    if (index >= 0 && index < consumedFoods.length) {
      final food = consumedFoods[index];

      consumedCalories.value -= food.calories;
      consumedProtein.value -= food.protein;
      consumedCarbs.value -= food.carbs;
      consumedFat.value -= food.fat;

      if (food.iron != null) consumedIron.value -= food.iron!;
      if (food.calcium != null) consumedCalcium.value -= food.calcium!;
      if (food.vitaminD != null) consumedVitaminD.value -= food.vitaminD!;
      if (food.zinc != null) consumedZinc.value -= food.zinc!;

      consumedFoods.removeAt(index);

      saveData();

      Get.snackbar(
        'Berhasil',
        'Makanan dihapus dari daftar',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    }
  }

  Future<void> resetDaily() async {
    try {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Reset Data Harian'),
          content: const Text(
              'Apakah Anda yakin ingin menghapus semua data makanan yang sudah dicatat hari ini?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Reset', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (result == true) {
        consumedCalories.value = 0;
        consumedProtein.value = 0;
        consumedCarbs.value = 0;
        consumedFat.value = 0;

        consumedIron.value = 0;
        consumedCalcium.value = 0;
        consumedVitaminD.value = 0;
        consumedZinc.value = 0;

        consumedFoods.clear();

        saveData();

        Get.snackbar(
          'Berhasil',
          'Data harian berhasil direset',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mereset data: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  void checkNutritionStatus() {
    if (targetCalories.value == 0) return;

    List<String> lowNutrients = [];

    if ((consumedCalories.value / targetCalories.value) < 0.7) {
      lowNutrients.add('Kalori');
    }
    if ((consumedProtein.value / targetProtein.value) < 0.7) {
      lowNutrients.add('Protein');
    }
    if ((consumedCarbs.value / targetCarbs.value) < 0.7) {
      lowNutrients.add('Karbohidrat');
    }
    if ((consumedFat.value / targetFat.value) < 0.7) {
      lowNutrients.add('Lemak');
    }

    if (targetIron.value > 0 && (consumedIron.value / targetIron.value) < 0.7) {
      lowNutrients.add('Zat Besi');
    }
    if (targetCalcium.value > 0 &&
        (consumedCalcium.value / targetCalcium.value) < 0.7) {
      lowNutrients.add('Kalsium');
    }

    if (lowNutrients.isNotEmpty) {
      Get.snackbar(
        'Peringatan Nutrisi',
        '${lowNutrients.join(", ")} masih kurang dari 70% kebutuhan harian',
        backgroundColor: Colors.yellow[100],
        colorText: Colors.orange[900],
        duration: const Duration(seconds: 5),
      );
    }
  }

  Map<String, double> getNutritionPercentages() {
    if (targetCalories.value == 0) {
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
    }

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
