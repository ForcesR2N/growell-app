import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:growell_app/models/food_nutrition_model.dart';

class DailyNutritionController extends GetxController {
  // Target nutrisi harian
  final targetCalories = 0.0.obs;
  final targetProtein = 0.0.obs;
  final targetCarbs = 0.0.obs;
  final targetFat = 0.0.obs;
  
  // Nutrisi yang sudah dikonsumsi
  final consumedCalories = 0.0.obs;
  final consumedProtein = 0.0.obs;
  final consumedCarbs = 0.0.obs;
  final consumedFat = 0.0.obs;
  
  // Loading state
  final isLoading = false.obs;

  // Error messages
  final ageError = RxString('');
  final weightError = RxString('');

  // Daftar makanan yang dikonsumsi hari ini
  final consumedFoods = <FoodNutrition>[].obs;

  // Hitung kebutuhan nutrisi berdasarkan usia dan berat
  void calculateRequirements(String age, String weight) {
    try {
      isLoading.value = true;
      
      // Validate input
      if (!_validateInput(age, weight)) return;
      
      final ageInMonths = int.parse(age);
      final weightInKg = double.parse(weight);

      if (ageInMonths <= 6) {
        targetCalories.value = weightInKg * 115;  // 110-120 kcal/kg/hari
        targetProtein.value = weightInKg * 2.2;   // 2.2g/kg/hari
        targetCarbs.value = weightInKg * 12;      // 12g/kg/hari
        targetFat.value = weightInKg * 6;         // 6g/kg/hari
      } else if (ageInMonths <= 12) {
        targetCalories.value = weightInKg * 105;  // 100-110 kcal/kg/hari
        targetProtein.value = weightInKg * 1.6;   // 1.6g/kg/hari
        targetCarbs.value = weightInKg * 14;      // 14g/kg/hari
        targetFat.value = weightInKg * 5;         // 5g/kg/hari
      } else {
        targetCalories.value = weightInKg * 95;   // 90-100 kcal/kg/hari
        targetProtein.value = weightInKg * 1.2;   // 1.2g/kg/hari
        targetCarbs.value = weightInKg * 16;      // 16g/kg/hari
        targetFat.value = weightInKg * 4;         // 4g/kg/hari
      }
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

  // Tambah makanan yang dikonsumsi
  void addFood(FoodNutrition food, double consumedPortion) {
    try {
      final adjustedFood = food.adjustPortion(consumedPortion);
      consumedFoods.add(adjustedFood);
      
      // Update total nutrisi
      consumedCalories.value += adjustedFood.calories;
      consumedProtein.value += adjustedFood.protein;
      consumedCarbs.value += adjustedFood.carbs;
      consumedFat.value += adjustedFood.fat;

      // Check nutrisi dan beri peringatan jika perlu
      checkNutritionStatus();

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

  // Reset data harian
  void resetDaily() {
    consumedCalories.value = 0;
    consumedProtein.value = 0;
    consumedCarbs.value = 0;
    consumedFat.value = 0;
    consumedFoods.clear();
  }

  // Check status nutrisi dan beri peringatan jika ada yang kurang
  void checkNutritionStatus() {
    if (targetCalories.value == 0) return; // Skip if requirements not set

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

  // Validate input
  bool _validateInput(String age, String weight) {
    bool isValid = true;
    
    // Clear previous errors
    ageError.value = '';
    weightError.value = '';
    
    // Validate age
    try {
      final ageNum = int.parse(age);
      if (ageNum <= 0 || ageNum > 24) {
        ageError.value = 'Usia harus antara 1-24 bulan';
        isValid = false;
      }
    } catch (e) {
      ageError.value = 'Usia tidak valid';
      isValid = false;
    }
    
    // Validate weight
    try {
      final weightNum = double.parse(weight);
      if (weightNum <= 0 || weightNum > 30) {
        weightError.value = 'Berat badan tidak valid';
        isValid = false;
      }
    } catch (e) {
      weightError.value = 'Berat badan tidak valid';
      isValid = false;
    }
    
    return isValid;
  }

  // Get nutrition percentages for progress bars
  Map<String, double> getNutritionPercentages() {
    if (targetCalories.value == 0) return {
      'calories': 0,
      'protein': 0,
      'carbs': 0,
      'fat': 0,
    };

    return {
      'calories': (consumedCalories.value / targetCalories.value) * 100,
      'protein': (consumedProtein.value / targetProtein.value) * 100,
      'carbs': (consumedCarbs.value / targetCarbs.value) * 100,
      'fat': (consumedFat.value / targetFat.value) * 100,
    };
  }
}