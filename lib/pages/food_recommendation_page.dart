import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/controllers/food_recommendation.controller.dart';
import 'package:growell_app/controllers/navigation_controller.dart';
import 'package:growell_app/routes/app_pages.dart';
import 'package:growell_app/widgets/food_detail_card.dart';

class FoodRecommendationPage extends StatefulWidget {
  final String ageGroup;
  final String title;

  FoodRecommendationPage({
    Key? key,
    required this.ageGroup,
    required this.title,
  }) : super(key: key);

  @override
  State<FoodRecommendationPage> createState() => _FoodRecommendationPageState();
}

class _FoodRecommendationPageState extends State<FoodRecommendationPage>
    with SingleTickerProviderStateMixin {
  final FoodRecommendationController controller =
      Get.put(FoodRecommendationController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    controller.getFoodRecommendation(widget.ageGroup);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Obx(() {
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

            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF6ED),
                        image: DecorationImage(
                          image: AssetImage('assets/images/food_header.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top,
                      left: 8,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Color(0xFF91C788),
                    labelColor: Color(0xFF91C788),
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'RINGKASAN'),
                      Tab(text: 'JADWAL'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.description,
                              style: const TextStyle(
                                color: Color(0xFF6F6F6F),
                                fontSize: 16,
                                fontFamily: 'Raleway',
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (data.mainFeeding.isNotEmpty) ...[
                              const Text(
                                'Makanan Utama',
                                style: TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontSize: 18,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data.mainFeeding,
                                style: const TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontSize: 16,
                                  fontFamily: 'Raleway',
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                            if (data.nutritionNeeds != null) ...[
                              const Text(
                                'Kebutuhan Nutrisi',
                                style: TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontSize: 18,
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
                            if (data.tips.isNotEmpty) ...[
                              const Text(
                                'Tips dan Panduan',
                                style: TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontSize: 18,
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
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data.feedingSchedule != null) ...[
                              const Text(
                                'Jadwal Pemberian',
                                style: TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontSize: 18,
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
                                child: FeedingScheduleSection(
                                    schedule: data.feedingSchedule),
                              ),
                              const SizedBox(height: 24),
                            ],
                            if (data.recommendedFoods != null &&
                                data.recommendedFoods!.isNotEmpty) ...[
                              const Text(
                                'Rekomendasi Makanan',
                                style: TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontSize: 18,
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
                                child: RecommendedFoodsSection(
                                    foods: data.recommendedFoods!),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFF91C788),
                ),
                child: TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.HOME);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      try {
                        final controller =
                            Get.find<BottomNavigationController>();
                        controller.navigateToTab(
                            BottomNavigationController.DAILY_NUTRITION_TAB);
                      } catch (e) {
                        print("Error changing tab: $e");
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, 
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text(
                    'HITUNG KEBUTUHAN NUTRISI BAYI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}