import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import '../models/baby_profile_model.dart';
import '../service/storage_service.dart';
import '../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final AuthService _authService = Get.find();
  final StorageService _storageService = Get.find();

  final pageController = PageController();
  final currentPage = 0.obs;

  final name = ''.obs;
  final age = 0.obs;
  final weight = 0.0.obs;
  final gender = 'male'.obs;
  final mealsPerDay = 3.obs;
  final hasAllergy = false.obs;
  final activityLevel = 5.0.obs;

  final nameError = RxString('');
  final ageError = RxString('');
  final weightError = RxString('');

  void nextPage() {
    if (!validateCurrentPage()) {
      Get.snackbar(
        'Validasi',
        'Mohon lengkapi data dengan benar',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (currentPage.value < 6) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      submitProfile();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void showValidationError(String message) {
    Get.snackbar(
      'Validasi',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.red,
      ),
    );
  }

  bool validateCurrentPage() {
    clearErrors();

    switch (currentPage.value) {
      case 0:
        if (name.value.isEmpty) {
          nameError.value = 'Nama tidak boleh kosong';
          return false;
        }
        return true;

      case 1: // Validasi usia
        if (age.value <= 0) {
          ageError.value = 'Masukkan usia bayi yang valid';
          showValidationError('Masukkan usia bayi yang valid');
          return false;
        }
        if (age.value < 1) {
          ageError.value = 'Usia minimal 1 bulan';
          showValidationError('Usia minimal 1 bulan');
          return false;
        }
        if (age.value > 24) {
          ageError.value = 'Usia maksimal 24 bulan';
          showValidationError('Usia maksimal 24 bulan');
          return false;
        }
        return true;

      case 2:
        if (weight.value <= 0) {
          weightError.value = 'Berat badan harus lebih dari 0 kg';
          return false;
        }
        if (weight.value > 30) {
          weightError.value = 'Berat badan tidak valid';
          return false;
        }
        return true;

      case 3: // Gender
        return true;

      case 4: // Meals per day
        return mealsPerDay.value >= 2 && mealsPerDay.value <= 6;

      case 5: // Allergy
        return true;

      case 6: // Activity level
        return activityLevel.value >= 1 && activityLevel.value <= 10;

      default:
        return false;
    }
  }

  void clearErrors() {
    nameError.value = '';
    ageError.value = '';
    weightError.value = '';
  }

  Future<void> submitProfile() async {
    try {
      final profile = BabyProfile(
        userId: _authService.user.value!.uid,
        name: name.value,
        age: age.value,
        weight: weight.value,
        gender: gender.value,
        mealsPerDay: mealsPerDay.value,
        hasAllergy: hasAllergy.value,
        activityLevel: activityLevel.value,
      );

      await _storageService.saveBabyProfile(profile);
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menyimpan profil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
