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
      Future.delayed(Duration.zero, () {
        Get.snackbar(
          'Error',
          'Gagal memuat data profil',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      });
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

    weightError.value =
        _validationService.validateBabyWeight(weight.value.toString());
    if (weightError.value.isNotEmpty) isValid = false;

    final mealsError =
        _validationService.validateMealsPerDay(mealsPerDay.value);
    if (mealsError.isNotEmpty) {
      _errorHandler.showWarningSnackbar('Validasi', mealsError);
      isValid = false;
    }

    final activityError =
        _validationService.validateActivityLevel(activityLevel.value);
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
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    if (!validateForm()) {
      _errorHandler.showWarningSnackbar(
        'Validasi',
        'Mohon lengkapi data dengan benar',
      );
      return;
    }

    try {
      isLoading.value = true;

      _showLoadingDialog();

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

      Get.back();

      _showSuccessDialog();

      Future.delayed(const Duration(milliseconds: 2000), () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        Get.back();
      });
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      _errorHandler.handleError(e, fallbackMessage: 'Gagal memperbarui profil');
    } finally {
      isLoading.value = false;
    }
  }

  void _showLoadingDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF91C788)),
                strokeWidth: 3,
              ),
              SizedBox(height: 15),
              Text(
                'Menyimpan...',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Signika',
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFF91C788),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Berhasil!',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Profil berhasil diperbarui',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Signika',
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
