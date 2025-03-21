import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import 'package:growell_app/service/error_handling_service.dart';
import 'package:growell_app/service/validation_service.dart';
import '../models/baby_profile_model.dart';
import '../service/storage_service.dart';
import '../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final AuthService _authService = Get.find();
  final StorageService _storageService = Get.find();
  final ErrorHandlingService _errorHandler = Get.find<ErrorHandlingService>();
  final ValidationService _validationService = Get.find<ValidationService>();

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
      _errorHandler.showWarningSnackbar(
        'Validasi',
        'Mohon lengkapi data dengan benar',
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

  bool validateCurrentPage() {
    clearErrors();

    switch (currentPage.value) {
      case 0:
        nameError.value = _validationService.validateBabyName(name.value);
        return nameError.value.isEmpty;

      case 1: // Validasi usia
        ageError.value = _validationService.validateBabyAge(age.value.toString());
        if (ageError.value.isNotEmpty) {
          _showValidationError(ageError.value);
          return false;
        }
        return true;

      case 2:
        weightError.value = _validationService.validateBabyWeight(weight.value.toString());
        return weightError.value.isEmpty;

      case 3: // Gender
        return true;

      case 4: // Meals per day
        final mealsError = _validationService.validateMealsPerDay(mealsPerDay.value);
        if (mealsError.isNotEmpty) {
          _showValidationError(mealsError);
          return false;
        }
        return true;

      case 5: // Allergy
        return true;

      case 6: // Activity level
        final activityError = _validationService.validateActivityLevel(activityLevel.value);
        if (activityError.isNotEmpty) {
          _showValidationError(activityError);
          return false;
        }
        return true;

      default:
        return false;
    }
  }

  void _showValidationError(String message) {
    _errorHandler.showWarningSnackbar('Validasi', message);
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
      _errorHandler.showSuccessSnackbar(
        'Sukses', 
        'Profil bayi berhasil disimpan'
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      _errorHandler.handleError(e, fallbackMessage: 'Terjadi kesalahan saat menyimpan profil');
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}