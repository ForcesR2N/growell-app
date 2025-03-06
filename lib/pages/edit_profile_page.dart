import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growell_app/controllers/edit_profile_controller.dart';


class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit Profil Bayi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontFamily: 'Signika',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEEF6ED),
                        border: Border.all(
                          color: const Color(0xFF91C788),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.face_rounded,
                          size: 50,
                          color: Color(0xFF91C788),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nama Input
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF6ED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller:
                            TextEditingController(text: controller.name.value)
                              ..selection = TextSelection.fromPosition(
                                  TextPosition(
                                      offset: controller.name.value.length)),
                        onChanged: (value) => controller.name.value = value,
                        decoration: InputDecoration(
                          labelText: 'Nama Bayi',
                          labelStyle: const TextStyle(
                            color: Color(0xFF91C788),
                            fontFamily: 'Signika',
                          ),
                          errorText: controller.nameError.value.isEmpty
                              ? null
                              : controller.nameError.value,
                          border: InputBorder.none,
                        ),
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(
                          fontFamily: 'Signika',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Usia dan Berat
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF6ED),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: TextEditingController(
                                    text: controller.age.value.toString())
                                  ..selection = TextSelection.fromPosition(
                                      TextPosition(
                                          offset: controller.age
                                              .toString()
                                              .length)),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                onChanged: (value) {
                                  controller.age.value =
                                      int.tryParse(value) ?? 0;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Usia (bulan)',
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF91C788),
                                    fontFamily: 'Signika',
                                  ),
                                  errorText: controller.ageError.value.isEmpty
                                      ? null
                                      : controller.ageError.value,
                                  border: InputBorder.none,
                                  hintText: '1-24',
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Signika',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF6ED),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: TextEditingController(
                                    text: controller.weight.value.toString())
                                  ..selection = TextSelection.fromPosition(
                                      TextPosition(
                                          offset: controller.weight
                                              .toString()
                                              .length)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                onChanged: (value) {
                                  controller.weight.value =
                                      double.tryParse(value) ?? 0.0;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Berat (kg)',
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF91C788),
                                    fontFamily: 'Signika',
                                  ),
                                  errorText:
                                      controller.weightError.value.isEmpty
                                          ? null
                                          : controller.weightError.value,
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Signika',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Jenis Kelamin
                      const Text(
                        'Jenis Kelamin',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.gender.value = 'male',
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: controller.gender.value == 'male'
                                      ? const Color(0xFF91C788)
                                      : const Color(0xFFEEF6ED),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.male_rounded,
                                      color: controller.gender.value == 'male'
                                          ? Colors.white
                                          : const Color(0xFF91C788),
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Laki-laki',
                                      style: TextStyle(
                                        color: controller.gender.value == 'male'
                                            ? Colors.white
                                            : Colors.black87,
                                        fontFamily: 'Signika',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.gender.value = 'female',
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: controller.gender.value == 'female'
                                      ? const Color(0xFF91C788)
                                      : const Color(0xFFEEF6ED),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.female_rounded,
                                      color: controller.gender.value == 'female'
                                          ? Colors.white
                                          : const Color(0xFF91C788),
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Perempuan',
                                      style: TextStyle(
                                        color:
                                            controller.gender.value == 'female'
                                                ? Colors.white
                                                : Colors.black87,
                                        fontFamily: 'Signika',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Frekuensi Makan
                      const Text(
                        'Frekuensi Makan per Hari',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF6ED),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [2, 3, 4]
                                  .map((value) => _buildMealOption(value))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [5, 6]
                                  .map((value) => _buildMealOption(value))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Alergi
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF6ED),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Memiliki Alergi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    controller.hasAllergy.value
                                        ? 'Ya, memiliki alergi'
                                        : 'Tidak ada alergi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Signika',
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: controller.hasAllergy.value,
                              onChanged: (value) =>
                                  controller.hasAllergy.value = value,
                              activeColor: const Color(0xFF91C788),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tingkat Aktivitas
                      const Text(
                        'Tingkat Aktivitas',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Signika',
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF6ED),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Level ${controller.activityLevel.value.round()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Signika',
                                    color: Color(0xFF91C788),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  _getActivityIcon(
                                      controller.activityLevel.value.round()),
                                  color: const Color(0xFF91C788),
                                  size: 24,
                                ),
                              ],
                            ),
                            SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: const Color(0xFF91C788),
                                inactiveTrackColor: Colors.grey[300],
                                thumbColor: const Color(0xFF91C788),
                                overlayColor:
                                    const Color(0xFF91C788).withOpacity(0.2),
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
                            ),
                            Text(
                              _getActivityDescription(
                                  controller.activityLevel.value.round()),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Signika',
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Update Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF91C788),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMealOption(int value) {
    return GestureDetector(
      onTap: () => controller.mealsPerDay.value = value,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: controller.mealsPerDay.value == value
              ? const Color(0xFF91C788)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$value',
              style: TextStyle(
                color: controller.mealsPerDay.value == value
                    ? Colors.white
                    : const Color(0xFF91C788),
                fontSize: 20,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'kali',
              style: TextStyle(
                color: controller.mealsPerDay.value == value
                    ? Colors.white
                    : Colors.black87,
                fontSize: 12,
                fontFamily: 'Signika',
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(int level) {
    if (level <= 3) {
      return Icons.nightlight_outlined;
    } else if (level <= 7) {
      return Icons.directions_walk;
    } else {
      return Icons.directions_run;
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
