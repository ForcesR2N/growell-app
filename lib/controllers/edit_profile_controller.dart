import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import 'package:growell_app/models/baby_profile_model.dart';
import 'package:growell_app/service/storage_service.dart';

class EditProfileController extends GetxController {
  final AuthService _authService = Get.find();
  final StorageService _storageService = Get.find();

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

    if (name.value.isEmpty) {
      nameError.value = 'Nama tidak boleh kosong';
      isValid = false;
    }

    if (age.value <= 0) {
      ageError.value = 'Masukkan usia bayi yang valid';
      isValid = false;
    } else if (age.value > 24) {
      ageError.value = 'Usia maksimal 24 bulan';
      isValid = false;
    }

    if (weight.value <= 0) {
      weightError.value = 'Berat badan harus lebih dari 0 kg';
      isValid = false;
    } else if (weight.value > 30) {
      weightError.value = 'Berat badan tidak valid';
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
      Get.snackbar(
        'Validasi',
        'Mohon lengkapi data dengan benar',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
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
      Get.back();
      Get.snackbar(
        'Sukses',
        'Profil berhasil diperbarui',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui profil',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }
}