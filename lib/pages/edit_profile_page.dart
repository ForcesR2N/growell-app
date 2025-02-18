import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growell_app/controllers/edit_profile_controller.dart';
import 'package:growell_app/widgets/app_values.dart';
import 'package:growell_app/widgets/custom_button.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil Bayi'),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama
              TextField(
                controller: TextEditingController(text: controller.name.value)
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.name.value.length)),
                onChanged: (value) => controller.name.value = value,
                decoration: InputDecoration(
                  labelText: 'Nama Bayi',
                  errorText: controller.nameError.value.isEmpty
                      ? null
                      : controller.nameError.value,
                  border: const OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Usia
              TextField(
                controller: TextEditingController(
                    text: controller.age.value.toString())
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.age.toString().length)),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                onChanged: (value) {
                  controller.age.value = int.tryParse(value) ?? 0;
                },
                decoration: InputDecoration(
                  labelText: 'Usia (bulan)',
                  errorText: controller.ageError.value.isEmpty
                      ? null
                      : controller.ageError.value,
                  border: const OutlineInputBorder(),
                  hintText: '1-24 bulan',
                ),
              ),
              const SizedBox(height: 16),

              // Berat
              TextField(
                controller: TextEditingController(
                    text: controller.weight.value.toString())
                  ..selection = TextSelection.fromPosition(TextPosition(
                      offset: controller.weight.toString().length)),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  controller.weight.value = double.tryParse(value) ?? 0.0;
                },
                decoration: InputDecoration(
                  labelText: 'Berat Badan (kg)',
                  errorText: controller.weightError.value.isEmpty
                      ? null
                      : controller.weightError.value,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Jenis Kelamin
              const Text('Jenis Kelamin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
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
              ),
              const SizedBox(height: 24),

              // Frekuensi Makan
              const Text('Frekuensi Makan per Hari',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Slider(
                value: controller.mealsPerDay.value.toDouble(),
                min: 2,
                max: 6,
                divisions: 4,
                label: '${controller.mealsPerDay.value}x sehari',
                onChanged: (value) =>
                    controller.mealsPerDay.value = value.round(),
              ),
              const SizedBox(height: 24),

              // Alergi
              SwitchListTile(
                title: const Text('Memiliki Alergi',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Text(controller.hasAllergy.value
                    ? 'Ya, memiliki alergi'
                    : 'Tidak ada alergi'),
                value: controller.hasAllergy.value,
                onChanged: (value) => controller.hasAllergy.value = value,
              ),
              const SizedBox(height: 24),

              // Tingkat Aktivitas
              const Text('Tingkat Aktivitas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Slider(
                value: controller.activityLevel.value,
                min: 1,
                max: 10,
                divisions: 9,
                label: 'Level ${controller.activityLevel.value.round()}',
                onChanged: (value) => controller.activityLevel.value = value,
              ),
              Text(
                _getActivityDescription(
                    controller.activityLevel.value.round()),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Update Button
              CustomButton(
                text: 'Simpan Perubahan',
                width: double.infinity,
                onPressed: controller.updateProfile,
                isLoading: controller.isLoading.value,
              ),
            ],
          ),
        );
      }),
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