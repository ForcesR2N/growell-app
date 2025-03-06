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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF91C788)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF91C788),
            fontSize: 25,
            fontFamily: 'Signika',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF91C788)),
          ));
        }

        final data = controller.recommendationData.value;
        if (data == null) {
          return const Center(
            child: Text(
              'Tidak ada data tersedia',
              style: TextStyle(
                color: Color(0xFF7B7B7B),
                fontFamily: 'Signika',
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDED4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.description,
                      style: const TextStyle(
                        color: Color(0xFF6F6F6F),
                        fontSize: 16,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (data.mainFeeding.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Makanan Utama: ${data.mainFeeding}',
                        style: const TextStyle(
                          color: Color(0xFF6F6F6F),
                          fontSize: 14,
                          fontFamily: 'Raleway',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Feeding Schedule
              if (data.feedingSchedule != null) ...[
                const Text(
                  'Jadwal Pemberian',
                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 20,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D4FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: FeedingScheduleSection(schedule: data.feedingSchedule),
                ),
                const SizedBox(height: 24),
              ],

              // Nutrition Section
              if (data.nutritionNeeds != null) ...[
                const Text(
                  'Kebutuhan Nutrisi',
                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 20,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5C1C1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: NutritionSection(
                    nutrition: data.nutritionNeeds,
                    importantNutrients: data.importantNutrients,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Recommended Foods
              if (data.recommendedFoods != null &&
                  data.recommendedFoods!.isNotEmpty) ...[
                const Text(
                  'Rekomendasi Makanan',
                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 20,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC3F5C1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: RecommendedFoodsSection(foods: data.recommendedFoods!),
                ),
                const SizedBox(height: 24),
              ],

              // Tips Section
              if (data.tips.isNotEmpty) ...[
                const Text(
                  'Tips dan Panduan',
                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 20,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDED4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TipsSection(tips: data.tips),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
