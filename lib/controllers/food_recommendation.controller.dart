import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/models/food_recommendation_model.dart';

class FoodRecommendationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isLoading = true.obs;
  final Rx<FoodRecommendation?> recommendationData = Rx<FoodRecommendation?>(null);

  Future<void> getFoodRecommendation(String ageGroupId) async {
    try {
      isLoading.value = true;

      final doc = await _firestore
          .collection('foodRecommendations')
          .doc(ageGroupId)
          .get();

      if (doc.exists) {
        print('Raw Firebase data: ${doc.data()}');
        
        final data = doc.data() ?? {};
        recommendationData.value = FoodRecommendation.fromJson(data);
 
        print('Parsed data:');
        print('Description: ${recommendationData.value?.description}');
        print('Nutrition Needs: ${recommendationData.value?.nutritionNeeds.calories}');
        print('Important Nutrients: ${recommendationData.value?.importantNutrients?.length}');
        print('Tips: ${recommendationData.value?.tips}');
        
      } else {
        throw Exception('Data tidak ditemukan');
      }
    } catch (e) {
      print('Error in getFoodRecommendation: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data rekomendasi makanan: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }
}