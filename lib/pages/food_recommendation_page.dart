import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/controllers/food_recommendation.controller.dart';
import 'package:growell_app/widgets/app_values.dart';
import 'package:growell_app/widgets/food_detail_card.dart';

class FoodRecommendationPage extends StatelessWidget {
  final FoodRecommendationController controller =
      Get.put(FoodRecommendationController());
  final String ageGroup;
  final String title;

  FoodRecommendationPage({
    Key? key,
    required this.ageGroup,
    required this.title,
  }) : super(key: key) {
    controller.getFoodRecommendation(ageGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.recommendationData.value;
        if (data == null) {
          return const Center(
            child: Text('Tidak ada data tersedia'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Info
              MainInfoSection(data: data),
              const SizedBox(height: 16),

              // Feeding Schedule
              if (data.feedingSchedule != null)
                FeedingScheduleSection(schedule: data.feedingSchedule),
              const SizedBox(height: 16),

              // Nutrition Section
              if (data.nutritionNeeds != null)
                NutritionSection(
                  nutrition: data.nutritionNeeds,
                  importantNutrients: data.importantNutrients,
                ),
              const SizedBox(height: 16),

              // Recommended Foods
              if (data.recommendedFoods != null && data.recommendedFoods!.isNotEmpty)
                RecommendedFoodsSection(foods: data.recommendedFoods!),
              const SizedBox(height: 16),

              // Tips Section
              if (data.tips.isNotEmpty)
                TipsSection(tips: data.tips),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }
}