import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growell_app/controllers/onBoarding_controller.dart';
import 'package:growell_app/widgets/app_values.dart';
import 'package:growell_app/widgets/custom_button.dart';
import 'package:growell_app/widgets/onBoarding_widget.dart';
import 'package:growell_app/components/onboarding_input.dart';
import 'package:growell_app/components/onboarding_progress.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPage(
                    title: 'Siapa nama si Kecil?',
                    subtitle: 'Masukkan nama lengkap bayi Anda',
                    child: _buildNameInput(),
                  ),
                  _buildPage(
                    title: 'Berapa usia si Kecil?',
                    subtitle: 'Masukkan usia dalam bulan (1-24 bulan)',
                    child: _buildAgeInput(),
                  ),
                  _buildWeightPage(),
                  _buildGenderPage(),
                  _buildMealsPage(),
                  _buildAllergyPage(),
                  _buildActivityPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Obx(() => OnboardingProgress(
                    currentPage: controller.currentPage.value,
                    totalPages: 7,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => controller.currentPage.value > 0
                      ? TextButton(
                          onPressed: controller.previousPage,
                          child: const Text(
                            'Kembali',
                            style: TextStyle(
                              color: Color(0xFF91C788),
                              fontSize: 16,
                              fontFamily: 'Signika',
                            ),
                          ),
                        )
                      : const SizedBox(width: 80)),
                  Container(
                    width: 150,
                    height: 57,
                    child: ElevatedButton(
                      onPressed: controller.nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF91C788),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        controller.currentPage.value < 6 ? 'Lanjut' : 'Selesai',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 171,
            child: Image.asset(
              'assets/images/Ilustration.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.85),
              fontSize: 25,
              fontFamily: 'Signika',
              fontWeight: FontWeight.w600,
              height: 1.4,
              letterSpacing: -0.24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.45),
              fontSize: 17,
              fontFamily: 'Signika',
              fontWeight: FontWeight.w400,
              height: 1.4,
              letterSpacing: -0.24,
            ),
          ),
          const SizedBox(height: 30),
          child,
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return OnboardingInput(
      hintText: 'Nama lengkap bayi',
      onChanged: (value) => controller.name.value = value,
      errorText: controller.nameError.value,
    );
  }

  Widget _buildAgeInput() {
    return OnboardingInput(
      hintText: 'Usia bayi (bulan)',
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      onChanged: (value) {
        if (value.isEmpty) {
          controller.age.value = 0;
          return;
        }
        controller.age.value = int.tryParse(value) ?? 0;
      },
      errorText: controller.ageError.value,
    );
  }

  Widget _buildWeightPage() {
    return _buildPage(
      title: 'Berapa berat badan si kecil?',
      subtitle: 'Masukkan berat badan dalam kilogram',
      child: Column(
        children: [
          OnboardingInput(
            hintText: 'Berat badan (kg)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
            ],
            onChanged: (value) {
              controller.weight.value = double.tryParse(value) ?? 0.0;
            },
            errorText: controller.weightError.value,
          ),
          if (controller.weight.value > 0)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Berat badan ${controller.weight.value} kg',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Signika',
                  color: Color(0xFF91C788),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGenderPage() {
    return _buildPage(
      title: 'Jenis kelamin si kecil?',
      subtitle: 'Pilih jenis kelamin bayi Anda',
      child: Column(
        children: [
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGenderOption(
                    title: 'Laki-laki',
                    icon: Icons.male_rounded,
                    value: 'male',
                    isSelected: controller.gender.value == 'male',
                  ),
                  const SizedBox(width: 20),
                  _buildGenderOption(
                    title: 'Perempuan',
                    icon: Icons.female_rounded,
                    value: 'female',
                    isSelected: controller.gender.value == 'female',
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildGenderOption({
    required String title,
    required IconData icon,
    required String value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.gender.value = value,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF91C788) : const Color(0xFFEEF6ED),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.white : const Color(0xFF91C788),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 16,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsPage() {
    return _buildPage(
      title: 'Berapa kali makan dalam sehari?',
      subtitle: 'Pilih frekuensi makan si kecil',
      child: Column(
        children: [
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMealOption(
                    value: 2,
                    isSelected: controller.mealsPerDay.value == 2,
                  ),
                  const SizedBox(width: 15),
                  _buildMealOption(
                    value: 3,
                    isSelected: controller.mealsPerDay.value == 3,
                  ),
                  const SizedBox(width: 15),
                  _buildMealOption(
                    value: 4,
                    isSelected: controller.mealsPerDay.value == 4,
                  ),
                ],
              )),
          const SizedBox(height: 20),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMealOption(
                    value: 5,
                    isSelected: controller.mealsPerDay.value == 5,
                  ),
                  const SizedBox(width: 15),
                  _buildMealOption(
                    value: 6,
                    isSelected: controller.mealsPerDay.value == 6,
                  ),
                ],
              )),
          const SizedBox(height: 30),
          Obx(() => Text(
                '${controller.mealsPerDay.value}x makan dalam sehari',
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Signika',
                  color: Color(0xFF91C788),
                  fontWeight: FontWeight.w600,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMealOption({
    required int value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.mealsPerDay.value = value,
      child: Container(
        width: 90,
        height: 90,
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF91C788) : const Color(0xFFEEF6ED),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$value',
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF91C788),
                fontSize: 32,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'kali',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 14,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergyPage() {
    return _buildPage(
      title: 'Apakah si kecil memiliki alergi?',
      subtitle: 'Informasi ini penting untuk rekomendasi makanan',
      child: Column(
        children: [
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAllergyOption(
                    title: 'Tidak',
                    icon: Icons.check_circle_outline,
                    value: false,
                    isSelected: !controller.hasAllergy.value,
                  ),
                  const SizedBox(width: 20),
                  _buildAllergyOption(
                    title: 'Ya',
                    icon: Icons.warning_amber_rounded,
                    value: true,
                    isSelected: controller.hasAllergy.value,
                  ),
                ],
              )),
          const SizedBox(height: 30),
          Obx(() => Text(
                controller.hasAllergy.value
                    ? 'Si kecil memiliki alergi'
                    : 'Tidak ada alergi yang diketahui',
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Signika',
                  color: Color(0xFF91C788),
                  fontWeight: FontWeight.w600,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAllergyOption({
    required String title,
    required IconData icon,
    required bool value,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.hasAllergy.value = value,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF91C788) : const Color(0xFFEEF6ED),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.white : const Color(0xFF91C788),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 16,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityPage() {
    return _buildPage(
      title: 'Seberapa aktif si kecil?',
      subtitle: 'Pilih tingkat aktivitas untuk menyesuaikan kebutuhan nutrisi',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: ShapeDecoration(
              color: const Color(0xFFEEF6ED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level ${controller.activityLevel.value.round()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Signika',
                            color: Color(0xFF91C788),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          _getActivityIcon(
                              controller.activityLevel.value.round()),
                          color: const Color(0xFF91C788),
                          size: 28,
                        ),
                      ],
                    )),
                const SizedBox(height: 10),
                Obx(() => SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: const Color(0xFF91C788),
                        inactiveTrackColor: Colors.grey[300],
                        thumbColor: const Color(0xFF91C788),
                        overlayColor: const Color(0xFF91C788).withOpacity(0.2),
                        trackHeight: 8,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 24,
                        ),
                      ),
                      child: Slider(
                        value: controller.activityLevel.value,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (value) =>
                            controller.activityLevel.value = value,
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Obx(() => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF6ED),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getActivityDescription(
                      controller.activityLevel.value.round()),
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Signika',
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      ),
    );
  }

  IconData _getActivityIcon(int level) {
    if (level <= 3) {
      return Icons.nightlight_outlined; // Untuk aktivitas rendah
    } else if (level <= 7) {
      return Icons.directions_walk; // Untuk aktivitas sedang
    } else {
      return Icons.directions_run; // Untuk aktivitas tinggi
    }
  }

  String _getActivityDescription(int level) {
    if (level <= 3) {
      return 'Aktivitas rendah\nLebih banyak tidur dan tenang';
    } else if (level <= 7) {
      return 'Aktivitas sedang\nBermain dan bergerak aktif';
    } else {
      return 'Aktivitas tinggi\nSangat aktif dan energik';
    }
  }
}
