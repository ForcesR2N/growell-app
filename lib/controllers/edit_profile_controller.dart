import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import 'package:growell_app/models/baby_profile_model.dart';
import 'package:growell_app/service/error_handling_service.dart';
import 'package:growell_app/service/storage_service.dart';
import 'package:growell_app/service/validation_service.dart';

class EditProfileController extends GetxController {
  final AuthService _authService = Get.find();
  final StorageService _storageService = Get.find();
  final ErrorHandlingService _errorHandler = Get.find<ErrorHandlingService>();
  final ValidationService _validationService = Get.find<ValidationService>();

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
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentProfile();
  }

  Future<void> loadCurrentProfile() async {
    try {
      isLoading.value = true;
      final profile = await _storageService
          .getBabyProfile(_authService.user.value!.uid)
          .first;

      if (profile != null) {
        name.value = profile.name;
        age.value = profile.age;
        weight.value = profile.weight;
        gender.value = profile.gender;
        mealsPerDay.value = profile.mealsPerDay;
        hasAllergy.value = profile.hasAllergy;
        activityLevel.value = profile.activityLevel;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data profil',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool validateForm() {
    bool isValid = true;
    clearErrors();

    nameError.value = _validationService.validateBabyName(name.value);
    if (nameError.value.isNotEmpty) isValid = false;

    ageError.value = _validationService.validateBabyAge(age.value.toString());
    if (ageError.value.isNotEmpty) isValid = false;

    weightError.value = _validationService.validateBabyWeight(weight.value.toString());
    if (weightError.value.isNotEmpty) isValid = false;

    final mealsError = _validationService.validateMealsPerDay(mealsPerDay.value);
    if (mealsError.isNotEmpty) {
      _errorHandler.showWarningSnackbar('Validasi', mealsError);
      isValid = false;
    }

    final activityError = _validationService.validateActivityLevel(activityLevel.value);
    if (activityError.isNotEmpty) {
      _errorHandler.showWarningSnackbar('Validasi', activityError);
      isValid = false;
    }

    return isValid;
  }

  void clearErrors() {
    nameError.value = '';
    ageError.value = '';
    weightError.value = '';
  }

  Future<void> updateProfile() async {
    if (!validateForm()) {
      _errorHandler.showWarningSnackbar(
        'Validasi',
        'Mohon lengkapi data dengan benar',
      );
      return;
    }

    try {
      isLoading.value = true;
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
        'Profil berhasil diperbarui',
      );
      Get.back();
    } catch (e) {
      _errorHandler.handleError(e, fallbackMessage: 'Gagal memperbarui profil');
    } finally {
      isLoading.value = false;
    }
  }
}