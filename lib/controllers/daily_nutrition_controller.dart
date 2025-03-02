import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:growell_app/models/food_nutrition_model.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

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
  final isSaving = false.obs;

  // Error messages
  final ageError = RxString('');
  final weightError = RxString('');

  // Input controllers
  final ageController = TextEditingController();
  final weightController = TextEditingController();

  // Daftar makanan yang dikonsumsi hari ini
  final consumedFoods = <FoodNutrition>[].obs;
  
  // Status berat badan
  final weightStatus = RxString('');
  final idealWeightLow = 0.0.obs;
  final idealWeightHigh = 0.0.obs;
  
  // Tanggal hari ini
  final currentDate = DateTime.now().obs;
  final dateFormatted = RxString('');

  @override
  void onInit() {
    super.onInit();
    // Format tanggal
    dateFormatted.value = DateFormat('dd MMMM yyyy').format(currentDate.value);
    
    // Load data dari shared preferences
    loadSavedData();
  }

  @override
  void onClose() {
    ageController.dispose();
    weightController.dispose();
    super.onClose();
  }

  // Load data yang tersimpan
  Future<void> loadSavedData() async {
    try {
      isLoading.value = true;
      
      final prefs = await SharedPreferences.getInstance();
      
      // Load data nutrisi target
      targetCalories.value = prefs.getDouble('targetCalories') ?? 0.0;
      targetProtein.value = prefs.getDouble('targetProtein') ?? 0.0;
      targetCarbs.value = prefs.getDouble('targetCarbs') ?? 0.0;
      targetFat.value = prefs.getDouble('targetFat') ?? 0.0;
      
      // Load data nutrisi yang dikonsumsi
      final savedDate = prefs.getString('nutritionDate') ?? '';
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // Jika data yang tersimpan masih untuk hari ini, load data
      if (savedDate == today) {
        consumedCalories.value = prefs.getDouble('consumedCalories') ?? 0.0;
        consumedProtein.value = prefs.getDouble('consumedProtein') ?? 0.0;
        consumedCarbs.value = prefs.getDouble('consumedCarbs') ?? 0.0;
        consumedFat.value = prefs.getDouble('consumedFat') ?? 0.0;
        
        // Load daftar makanan
        final foodsJson = prefs.getStringList('consumedFoods') ?? [];
        final foods = foodsJson.map((item) => 
          FoodNutrition.fromJson(json.decode(item))).toList();
        consumedFoods.assignAll(foods);
      }
      
      // Load data input user
      final savedAge = prefs.getString('inputAge') ?? '';
      final savedWeight = prefs.getString('inputWeight') ?? '';
      
      if (savedAge.isNotEmpty) {
        ageController.text = savedAge;
      }
      
      if (savedWeight.isNotEmpty) {
        weightController.text = savedWeight;
      }
      
      // Jika ada data target, calculte status berat badan
      if (targetCalories.value > 0 && savedAge.isNotEmpty && savedWeight.isNotEmpty) {
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

  // Simpan data ke shared preferences
  Future<void> saveData() async {
    try {
      isSaving.value = true;
      
      final prefs = await SharedPreferences.getInstance();
      
      // Simpan target nutrisi
      prefs.setDouble('targetCalories', targetCalories.value);
      prefs.setDouble('targetProtein', targetProtein.value);
      prefs.setDouble('targetCarbs', targetCarbs.value);
      prefs.setDouble('targetFat', targetFat.value);
      
      // Simpan nutrisi yang dikonsumsi
      prefs.setDouble('consumedCalories', consumedCalories.value);
      prefs.setDouble('consumedProtein', consumedProtein.value);
      prefs.setDouble('consumedCarbs', consumedCarbs.value);
      prefs.setDouble('consumedFat', consumedFat.value);
      
      // Simpan tanggal
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      prefs.setString('nutritionDate', today);
      
      // Simpan daftar makanan
      final foodsJson = consumedFoods.map((food) => 
        json.encode(food.toJson())).toList();
      prefs.setStringList('consumedFoods', foodsJson);
      
      // Simpan input user
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
      
      // Hitung status berat badan
      calculateWeightStatus(ageInMonths, weightInKg);
      
      // Simpan data
      saveData();
      
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

  // Hitung status berat badan berdasarkan usia
  void calculateWeightStatus(int ageInMonths, double weightInKg) {
    // Data WHO weight-for-age untuk anak laki-laki (digunakan sebagai estimasi umum)
    // Format: [usia dalam bulan, berat minimal (kg), berat maksimal (kg)]
    final weightChartData = [
      [0, 2.9, 4.4],   // lahir
      [1, 3.9, 5.8],   // 1 bulan
      [2, 4.9, 7.1],   // 2 bulan
      [3, 5.7, 8.0],   // 3 bulan
      [4, 6.2, 8.7],   // 4 bulan
      [5, 6.7, 9.3],   // 5 bulan
      [6, 7.1, 9.8],   // 6 bulan
      [7, 7.4, 10.3],  // 7 bulan
      [8, 7.7, 10.7],  // 8 bulan
      [9, 8.0, 11.0],  // 9 bulan
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
            if (ageInMonths > weightChartData[i][0] && ageInMonths < weightChartData[i+1][0]) {
              final lowerAge = weightChartData[i][0];
              final upperAge = weightChartData[i+1][0];
              final ratio = (ageInMonths - lowerAge) / (upperAge - lowerAge);
              
              final lowerMin = weightChartData[i][1];
              final upperMin = weightChartData[i+1][1];
              final lowerMax = weightChartData[i][2];
              final upperMax = weightChartData[i+1][2];
              
              final interpolatedMin = lowerMin + (upperMin - lowerMin) * ratio;
              final interpolatedMax = lowerMax + (upperMax - lowerMax) * ratio;
              
              return [ageInMonths, interpolatedMin, interpolatedMax];
            }
          }
          return weightChartData.first; // default ke 0 bulan jika tidak ditemukan
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

  // Dapat saran nutrisi berdasarkan status berat badan
  String getWeightStatusAdvice() {
    if (weightStatus.value == 'underweight') {
      return 'Berat badan si kecil kurang dari ideal. Tambahkan makanan padat gizi dan tinggi kalori seperti alpukat, ikan, dan makanan dengan lemak sehat. Tingkatkan frekuensi makan.';
    } else if (weightStatus.value == 'overweight') {
      return 'Berat badan si kecil lebih dari ideal. Pastikan porsi sesuai dan pilih makanan kaya nutrisi. Hindari makanan tinggi gula dan lemak jenuh. Tetap aktif bermain.';
    } else {
      return 'Berat badan si kecil sudah ideal. Pertahankan pola makan seimbang dan berikan variasi makanan sehat untuk mendukung tumbuh kembangnya.';
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
      
      // Simpan data
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

  // Hapus makanan dari daftar
  void removeFood(int index) {
    if (index >= 0 && index < consumedFoods.length) {
      final food = consumedFoods[index];
      
      // Kurangi nutrisi
      consumedCalories.value -= food.calories;
      consumedProtein.value -= food.protein;
      consumedCarbs.value -= food.carbs;
      consumedFat.value -= food.fat;
      
      // Hapus dari list
      consumedFoods.removeAt(index);
      
      // Simpan data
      saveData();
      
      Get.snackbar(
        'Berhasil',
        'Makanan dihapus dari daftar',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    }
  }

  // Reset data harian
  Future<void> resetDaily() async {
    try {
      // Tampilkan dialog konfirmasi
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Reset Data Harian'),
          content: const Text('Apakah Anda yakin ingin menghapus semua data makanan yang sudah dicatat hari ini?'),
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
        consumedFoods.clear();
        
        // Simpan data yang sudah direset
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