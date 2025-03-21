import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHandlingService extends GetxService {
  void onInit() {
    super.onInit();
  }

  String handleError(dynamic error, {String? fallbackMessage}) {
    String errorMessage = fallbackMessage ?? 'Terjadi kesalahan. Silakan coba lagi nanti.';
    
    // Handle different error types
    if (error is FirebaseAuthException) {
      errorMessage = _handleFirebaseAuthError(error);
    } else if (error is FirebaseException) {
      errorMessage = _handleFirebaseError(error);
    } else if (error is String) {
      errorMessage = error;
    } else if (error is Exception) {
      errorMessage = error.toString().replaceAll('Exception: ', '');
    }
    
    // Display the snackbar with the error message
    showErrorSnackbar(errorMessage);
    
    return errorMessage;
  }

  /// Handles specific Firebase Authentication errors and returns a user-friendly message.
  String _handleFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan';
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan';
      case 'weak-password':
        return 'Password terlalu lemah';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan coba lagi nanti';
      case 'requires-recent-login':
        return 'Silakan login kembali untuk melakukan tindakan ini';
      default:
        return error.message ?? 'Terjadi kesalahan pada autentikasi';
    }
  }

  /// Handles general Firebase errors and returns a user-friendly message.
  String _handleFirebaseError(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Tidak memiliki izin untuk mengakses data';
      case 'unavailable':
        return 'Layanan tidak tersedia. Silakan coba lagi nanti';
      case 'data-loss':
        return 'Data tidak dapat diakses atau rusak';
      default:
        return error.message ?? 'Terjadi kesalahan pada layanan Firebase';
    }
  }

  /// Displays an error snackbar
  void showErrorSnackbar(String message) {
    // Check if a snackbar is already open
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    
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

  /// Displays a success snackbar 
  void showSuccessSnackbar(String title, String message) {
    // Check if a snackbar is already open
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.green,
      ),
    );
  }

  void showWarningSnackbar(String title, String message) {
    // Check if a snackbar is already open
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange[100],
      colorText: Colors.orange[900],
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      icon: const Icon(
        Icons.warning_amber_outlined,
        color: Colors.orange,
      ),
    );
  }

  /// Displays a confirmation dialog.
  /// Returns true if confirmed, false otherwise.
  Future<bool> showConfirmationDialog(String title, String message) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
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
            child: const Text('Konfirmasi', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
}