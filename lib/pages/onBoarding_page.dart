import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/controllers/onBoarding_controller.dart';
import 'package:growell_app/widgets/app_values.dart';
import 'package:growell_app/widgets/custom_button.dart';
import 'package:growell_app/widgets/onBoarding_widget.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Obx(
                () => LinearProgressIndicator(
                  value: (controller.currentPage.value + 1) / 7,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),

            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildNamePage(),
                  _buildAgePage(),
                  _buildWeightPage(),
                  _buildGenderPage(),
                  _buildMealsPage(),
                  _buildAllergyPage(),
                  _buildActivityPage(),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(AppValues.padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => controller.currentPage.value > 0
                      ? TextButton.icon(
                          onPressed: controller.previousPage,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Kembali'),
                        )
                      : const SizedBox(width: 100)),
                  Obx(() {
                    bool isValid = controller.validateCurrentPage();
                    return CustomButton(
                      width: 120,
                      text: controller.currentPage.value < 6
                          ? 'Lanjut'
                          : 'Selesai',
                      onPressed: isValid ? () => controller.nextPage() : null,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNamePage() {
    return OnboardingWidget(
      title: 'Siapa nama si kecil?',
      subtitle: 'Masukkan nama lengkap bayi Anda',
      child: Column(
        children: [
          TextField(
            onChanged: (value) => controller.name.value = value,
            decoration: const InputDecoration(
              labelText: 'Nama Bayi',
              hintText: 'Contoh: Muhammad Azzam',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                controller.name.value.isEmpty
                    ? 'Silakan masukkan nama bayi'
                    : 'Halo ${controller.name.value}!',
                style: Get.textTheme.bodyLarge,
              )),
        ],
      ),
    );
  }

  Widget _buildAgePage() {
    return OnboardingWidget(
      title: 'Berapa usia si kecil?',
      subtitle: 'Masukkan usia dalam bulan (0-24 bulan)',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final age = int.tryParse(value) ?? 0;
                    controller.age.value = age > 24 ? 24 : age;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Usia',
                    suffixText: 'bulan',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                controller.age.value == 0
                    ? 'Silakan masukkan usia bayi'
                    : controller.age.value > 24
                        ? 'Maksimal usia 24 bulan'
                        : 'Usia ${controller.age.value} bulan',
                style: Get.textTheme.bodyLarge,
              )),
        ],
      ),
    );
  }

  Widget _buildWeightPage() {
    return OnboardingWidget(
      title: 'Berapa berat badan si kecil?',
      subtitle: 'Masukkan berat badan dalam kilogram',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    controller.weight.value = double.tryParse(value) ?? 0.0;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Berat Badan',
                    suffixText: 'kg',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                controller.weight.value == 0.0
                    ? 'Silakan masukkan berat badan bayi'
                    : 'Berat badan ${controller.weight.value} kg',
                style: Get.textTheme.bodyLarge,
              )),
        ],
      ),
    );
  }

  Widget _buildGenderPage() {
    return OnboardingWidget(
      title: 'Jenis kelamin si kecil?',
      subtitle: 'Pilih jenis kelamin bayi Anda',
      child: Column(
        children: [
          Obx(() => Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Laki-laki'),
                      value: 'male',
                      groupValue: controller.gender.value,
                      onChanged: (value) => controller.gender.value = value!,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Perempuan'),
                      value: 'female',
                      groupValue: controller.gender.value,
                      onChanged: (value) => controller.gender.value = value!,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildMealsPage() {
    return OnboardingWidget(
      title: 'Berapa kali makan dalam sehari?',
      subtitle: 'Pilih frekuensi makan si kecil',
      child: Column(
        children: [
          Obx(() => Slider(
                value: controller.mealsPerDay.value.toDouble(),
                min: 2,
                max: 6,
                divisions: 4,
                label: '${controller.mealsPerDay.value}x sehari',
                onChanged: (value) =>
                    controller.mealsPerDay.value = value.round(),
              )),
          const SizedBox(height: 16),
          Obx(() => Text(
                '${controller.mealsPerDay.value}x makan dalam sehari',
                style: Get.textTheme.bodyLarge,
              )),
        ],
      ),
    );
  }

  Widget _buildAllergyPage() {
    return OnboardingWidget(
      title: 'Apakah si kecil memiliki alergi?',
      subtitle: 'Informasi ini penting untuk rekomendasi makanan',
      child: Column(
        children: [
          Obx(() => SwitchListTile(
                title: const Text('Memiliki Alergi'),
                subtitle: Text(controller.hasAllergy.value
                    ? 'Ya, si kecil memiliki alergi'
                    : 'Tidak ada alergi yang diketahui'),
                value: controller.hasAllergy.value,
                onChanged: (value) => controller.hasAllergy.value = value,
              )),
        ],
      ),
    );
  }

  Widget _buildActivityPage() {
    return OnboardingWidget(
      title: 'Seberapa aktif si kecil?',
      subtitle: 'Pilih tingkat aktivitas untuk menyesuaikan kebutuhan nutrisi',
      child: Column(
        children: [
          Obx(() => Slider(
                value: controller.activityLevel.value,
                min: 1,
                max: 10,
                divisions: 9,
                label: 'Level ${controller.activityLevel.value.round()}',
                onChanged: (value) => controller.activityLevel.value = value,
              )),
          const SizedBox(height: 16),
          Obx(() => Text(
                _getActivityDescription(controller.activityLevel.value.round()),
                style: Get.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
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
