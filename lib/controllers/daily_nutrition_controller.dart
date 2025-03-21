import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/models/food_nutrition_model.dart';
import 'package:growell_app/service/error_handling_service.dart';
import 'package:growell_app/service/validation_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyNutritionController extends GetxController {
  late TextEditingController ageController;
  late TextEditingController weightController;
  final ErrorHandlingService _errorHandler = Get.find<ErrorHandlingService>();
  final ValidationService _validationService = Get.find<ValidationService>();

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
      ageController.dispose();
      weightController.dispose();
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
      _errorHandler.handleError(e,
          fallbackMessage: 'Error loading activity level');
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
      _errorHandler.handleError(e,
          fallbackMessage: 'Terjadi kesalahan saat memuat data');
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
      _errorHandler.handleError(e,
          fallbackMessage: 'Terjadi kesalahan saat menyimpan data');
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

      // Calculate requirements based on age and weight
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

      double activityFactor = 0.8 + (activityLevel.value / 10) * 0.4;
      targetCalories.value = baseCalories * activityFactor;

      // Calculate protein requirements (g/kg/day)
      if (ageInMonths <= 6) {
        targetProtein.value = weightInKg * 1.52;
      } else if (ageInMonths <= 12) {
        targetProtein.value = weightInKg * 1.5;
      } else {
        targetProtein.value = weightInKg * 1.1;
      }

      // Calculate carbs and fat from calorie distribution
      targetCarbs.value =
          (targetCalories.value * 0.55) / 4; 

      double fatPercentage;
      if (ageInMonths <= 6) {
        fatPercentage = 0.45;
      } else if (ageInMonths <= 12) {
        fatPercentage = 0.38;
      } else {
        fatPercentage = 0.33;
      }

      targetFat.value =
          (targetCalories.value * fatPercentage) / 9; 

      // Calculate micronutrient targets
      if (ageInMonths <= 6) {
        targetIron.value = 0.27;
      } else if (ageInMonths <= 12) {
        targetIron.value = 11.0;
      } else {
        targetIron.value = 7.0;
      }

      if (ageInMonths <= 6) {
        targetCalcium.value = 200.0;
      } else if (ageInMonths <= 12) {
        targetCalcium.value = 260.0;
      } else {
        targetCalcium.value = 700.0;
      }

      targetVitaminD.value = 10.0;

      if (ageInMonths <= 6) {
        targetZinc.value = 2.0;
      } else if (ageInMonths <= 12) {
        targetZinc.value = 3.0;
      } else {
        targetZinc.value = 3.0;
      }

      calculateWeightStatus(ageInMonths, weightInKg);

      saveData();

      _errorHandler.showSuccessSnackbar(
          'Kebutuhan Nutrisi', 'Kebutuhan nutrisi harian berhasil dihitung');
    } catch (e) {
      _errorHandler.handleError(e,
          fallbackMessage:
              'Terjadi kesalahan saat menghitung kebutuhan nutrisi');
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
              final lowerAge = weightChartData[i][0] as int;
              final upperAge = weightChartData[i + 1][0] as int;
              final ratio = (ageInMonths - lowerAge) / (upperAge - lowerAge);

              final lowerMin = weightChartData[i][1] as double;
              final upperMin = weightChartData[i + 1][1] as double;
              final lowerMax = weightChartData[i][2] as double;
              final upperMax = weightChartData[i + 1][2] as double;

              final interpolatedMin = lowerMin + (upperMin - lowerMin) * ratio;
              final interpolatedMax = lowerMax + (upperMax - lowerMax) * ratio;

              return [ageInMonths, interpolatedMin, interpolatedMax];
            }
          }
          return weightChartData.first;
        }
      },
    );

    double minWeight = (idealWeight[1] as num).toDouble();
    double maxWeight = (idealWeight[2] as num).toDouble();

    idealWeightLow.value = minWeight;
    idealWeightHigh.value = maxWeight;

    if (weightInKg < minWeight) {
      weightStatus.value = 'underweight';
    } else if (weightInKg > maxWeight) {
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

      _errorHandler.showSuccessSnackbar(
          'Berhasil', 'Makanan berhasil ditambahkan');
    } catch (e) {
      _errorHandler.handleError(e,
          fallbackMessage: 'Gagal menambahkan makanan');
    }
  }

  void removeFood(int index) {
    if (index >= 0 && index < consumedFoods.length) {
      try {
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

        _errorHandler.showSuccessSnackbar(
            'Berhasil', 'Makanan dihapus dari daftar');
      } catch (e) {
        _errorHandler.handleError(e,
            fallbackMessage: 'Gagal menghapus makanan');
      }
    }
  }

  Future<void> resetDaily() async {
    try {
      final result = await _errorHandler.showConfirmationDialog(
          'Reset Data Harian',
          'Apakah Anda yakin ingin menghapus semua data makanan yang sudah dicatat hari ini?');

      if (result) {
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

        _errorHandler.showSuccessSnackbar(
            'Berhasil', 'Data harian berhasil direset');
      }
    } catch (e) {
      _errorHandler.handleError(e, fallbackMessage: 'Gagal mereset data');
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
      _errorHandler.showWarningSnackbar('Peringatan Nutrisi',
          '${lowNutrients.join(", ")} masih kurang dari 70% kebutuhan harian');
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

  bool validateCustomFood(String name, String portion, String calories) {
    bool isValid = true;
    String nameError = _validationService.validateFoodName(name);
    String portionError = _validationService.validateFoodPortion(portion);
    String caloriesError = _validationService.validateFoodCalories(calories);

    if (nameError.isNotEmpty) {
      _errorHandler.showWarningSnackbar('Validasi', nameError);
      isValid = false;
    }

    if (portionError.isNotEmpty) {
      _errorHandler.showWarningSnackbar('Validasi', portionError);
      isValid = false;
    }

    if (caloriesError.isNotEmpty) {
      _errorHandler.showWarningSnackbar('Validasi', caloriesError);
      isValid = false;
    }

    return isValid;
  }
}
