import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import 'package:growell_app/service/error_handling_service.dart';
import 'package:growell_app/service/validation_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find();
  final ErrorHandlingService _errorHandler = Get.find<ErrorHandlingService>();
   final ValidationService _validationService = Get.find<ValidationService>();

  final RxBool isLoading = false.obs;
  final RxBool isLogin = true.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    errorMessage.value = '';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    errorMessage.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
  }

  void toggleAuthMode() {
    isLogin.toggle();
    clearForm();
  }

 bool validateForm() {
    bool isValid = true;

    // Use validation service for email
    emailError.value = _validationService.validateEmail(emailController.text);
    if (emailError.value.isNotEmpty) isValid = false;

    // Use validation service for password
    passwordError.value = _validationService.validatePassword(passwordController.text);
    if (passwordError.value.isNotEmpty) isValid = false;

    // If registering, validate password confirmation
    if (!isLogin.value) {
      confirmPasswordError.value = _validationService.validatePasswordConfirmation(
        passwordController.text,
        confirmPasswordController.text
      );
      if (confirmPasswordError.value.isNotEmpty) isValid = false;
    }

    return isValid;
  }

  Future<void> handleAuth() async {
    try {
      errorMessage.value = '';

      if (!validateForm()) return;

      isLoading.value = true;

      final result = isLogin.value
          ? await _authService.signIn(
              emailController.text.trim(),
              passwordController.text,
            )
          : await _authService.signUp(
              emailController.text.trim(),
              passwordController.text,
            );

      if (result != null) {
        clearForm();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _errorHandler.handleError(e);
    } catch (e) {
      errorMessage.value = _errorHandler.handleError(
        e,
        fallbackMessage: 'Terjadi kesalahan. Silakan coba lagi nanti.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}