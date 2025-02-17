import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find();

  final RxBool isLoading = false.obs;
  final RxBool isLogin = true.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    errorMessage.value = '';
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => isPasswordVisible.toggle();

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    errorMessage.value = '';
    emailError.value = '';
    passwordError.value = '';
  }

  void toggleAuthMode() {
    isLogin.toggle();
    clearForm();
  }

  bool validateForm() {
    bool isValid = true;
    
    if (emailController.text.isEmpty) {
      emailError.value = 'Email tidak boleh kosong';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Format email tidak valid';
      isValid = false;
    } else {
      emailError.value = '';
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password tidak boleh kosong';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password minimal 6 karakter';
      isValid = false;
    } else {
      passwordError.value = '';
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
        Get.offAllNamed(Routes.DATA_CHECK);
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseError(e);
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan. Silakan coba lagi nanti.';
      showErrorSnackbar(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        errorMessage.value = 'Format email tidak valid';
        break;
      case 'user-disabled':
        errorMessage.value = 'Akun ini telah dinonaktifkan';
        break;
      case 'user-not-found':
        errorMessage.value = 'Email tidak terdaftar';
        break;
      case 'wrong-password':
        errorMessage.value = 'Password salah';
        break;
      case 'email-already-in-use':
        errorMessage.value = 'Email sudah terdaftar';
        break;
      case 'operation-not-allowed':
        errorMessage.value = 'Operasi tidak diizinkan';
        break;
      case 'weak-password':
        errorMessage.value = 'Password terlalu lemah';
        break;
      case 'network-request-failed':
        errorMessage.value = 'Koneksi internet bermasalah';
        break;
      case 'too-many-requests':
        errorMessage.value = 'Terlalu banyak percobaan. Silakan coba lagi nanti';
        break;
      default:
        errorMessage.value = 'Terjadi kesalahan: ${e.message}';
    }
    showErrorSnackbar(errorMessage.value);
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[900],
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.red,
      ),
    );
  }
}