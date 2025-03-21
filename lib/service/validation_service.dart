import 'package:get/get.dart';

class ValidationService extends GetxService {
  /// Validates an email address.
  String validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    if (!GetUtils.isEmail(email)) {
      return 'Format email tidak valid';
    }
    
    return '';
  }

  /// Validates a password.
  String validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    return '';
  }

  /// Validates password confirmation.
  /// Returns an error message if not matching, empty string if valid.
  String validatePasswordConfirmation(String password, String confirmation) {
    if (confirmation.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    
    if (confirmation != password) {
      return 'Password tidak cocok';
    }
    
    return '';
  }

  /// Validates baby name.
  String validateBabyName(String name) {
    if (name.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    
    return '';
  }

  /// Validates baby age in months.
  String validateBabyAge(String ageString) {
    try {
      final age = int.parse(ageString);
      
      if (age <= 0) {
        return 'Masukkan usia bayi yang valid';
      }
      
      if (age < 1) {
        return 'Usia minimal 1 bulan';
      }
      
      if (age > 24) {
        return 'Usia maksimal 24 bulan';
      }
      
      return '';
    } catch (e) {
      return 'Usia tidak valid';
    }
  }

  /// Validates baby weight in kg.
  String validateBabyWeight(String weightString) {
    try {
      final weight = double.parse(weightString);
      
      if (weight <= 0) {
        return 'Berat badan harus lebih dari 0 kg';
      }
      
      if (weight > 30) {
        return 'Berat badan tidak valid';
      }
      
      return '';
    } catch (e) {
      return 'Berat badan tidak valid';
    }
  }

  /// Validates meals per day.
  String validateMealsPerDay(int meals) {
    if (meals < 2 || meals > 6) {
      return 'Frekuensi makan harus antara 2-6 kali per hari';
    }
    
    return '';
  }

  /// Validates activity level.
  String validateActivityLevel(double level) {
    if (level < 1 || level > 10) {
      return 'Tingkat aktivitas harus antara 1-10';
    }
    
    return '';
  }

  /// Validates food portion.
  String validateFoodPortion(String portionString) {
    try {
      final portion = double.parse(portionString);
      
      if (portion <= 0) {
        return 'Porsi harus lebih dari 0';
      }
      
      if (portion > 1000) {
        return 'Porsi terlalu besar';
      }
      
      return '';
    } catch (e) {
      return 'Porsi tidak valid';
    }
  }

  /// Validates food calories.
  String validateFoodCalories(String caloriesString) {
    try {
      final calories = double.parse(caloriesString);
      
      if (calories < 0) {
        return 'Kalori tidak boleh negatif';
      }
      
      return '';
    } catch (e) {
      return 'Masukkan nilai kalori yang valid';
    }
  }

  /// Validates food name.
  String validateFoodName(String name) {
    if (name.trim().isEmpty) {
      return 'Nama makanan tidak boleh kosong';
    }
    
    return '';
  }
}