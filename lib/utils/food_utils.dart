import 'package:flutter/material.dart';

class FoodUtils {
  static IconData getFoodGroupIcon(String foodGroup) {
    switch (foodGroup) {
      case 'Fruit':
        return Icons.apple;
      case 'Vegetable':
        return Icons.spa;
      case 'Grain':
        return Icons.grain;
      case 'Protein':
        return Icons.egg_alt;
      case 'Dairy':
        return Icons.coffee;
      default:
        return Icons.restaurant;
    }
  }
  
  static Color getFoodGroupColor(String foodGroup) {
    switch (foodGroup) {
      case 'Fruit':
        return Colors.orange;
      case 'Vegetable':
        return Colors.green;
      case 'Grain':
        return Colors.brown;
      case 'Protein':
        return Colors.red;
      case 'Dairy':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
  
  static String getFoodGroupTitle(String foodGroup) {
    switch (foodGroup) {
      case 'Fruit':
        return 'Buah';
      case 'Vegetable':
        return 'Sayuran';
      case 'Grain':
        return 'Biji-bijian';
      case 'Protein':
        return 'Protein';
      case 'Dairy':
        return 'Susu & Olahan';
      default:
        return 'Lainnya';
    }
  }
  
  static String getWeightStatusText(String status) {
    switch (status) {
      case 'underweight':
        return 'Berat Kurang';
      case 'overweight':
        return 'Berat Lebih';
      case 'normal':
        return 'Berat Normal';
      default:
        return 'Belum dihitung';
    }
  }
  
  static Color getWeightStatusColor(String status) {
    switch (status) {
      case 'underweight':
        return Colors.orange;
      case 'overweight':
        return Colors.orange;
      case 'normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}