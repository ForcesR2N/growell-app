import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import 'package:growell_app/models/baby_profile_model.dart';
import 'package:growell_app/service/storage_service.dart';
import 'package:growell_app/widgets/app_values.dart';
import 'package:growell_app/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final storageService = Get.find<StorageService>();
    final user = authService.user.value;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.padding),
          child: Column(
            children: [
              // Profile Image and Email Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    // Profile Image
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 64,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Email
                    Text(
                      user?.email ?? 'Email tidak tersedia',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Baby Profile Section
              StreamBuilder<BabyProfile?>(
                stream: storageService.getBabyProfile(user?.uid ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final babyProfile = snapshot.data;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              babyProfile?.gender == 'male'
                                  ? Icons.face
                                  : Icons.face_3,
                              color: Colors.blue,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              babyProfile?.name ?? 'Nama Bayi',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'Usia',
                          '${babyProfile?.age ?? 0} bulan',
                        ),
                        _buildInfoRow(
                          'Berat',
                          '${babyProfile?.weight ?? 0} kg',
                        ),
                        _buildInfoRow(
                          'Jenis Kelamin',
                          babyProfile?.gender == 'male'
                              ? 'Laki-laki'
                              : 'Perempuan',
                        ),
                        _buildInfoRow(
                          'Frekuensi Makan',
                          '${babyProfile?.mealsPerDay ?? 0}x sehari',
                        ),
                        _buildInfoRow(
                          'Memiliki Alergi',
                          babyProfile?.hasAllergy == true ? 'Ya' : 'Tidak',
                        ),
                        _buildInfoRow(
                          'Tingkat Aktivitas',
                          _getActivityLevel(babyProfile?.activityLevel ?? 5),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Edit Profile Button
              CustomButton(
                text: 'Edit Profil Bayi',
                width: double.infinity,
                onPressed: () {
                  // TODO: Navigate to edit profile page
                  Get.toNamed('/edit-profile');
                },
              ),

              const SizedBox(height: 16),

              // Logout Button
              CustomButton(
                text: 'Keluar',
                width: double.infinity,
                backgroundColor: Colors.red,
                onPressed: () async {
                  try {
                    await authService.signOut();
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Gagal keluar dari aplikasi',
                      backgroundColor: Colors.red[100],
                      colorText: Colors.red[900],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getActivityLevel(double level) {
    if (level <= 3) {
      return 'Rendah';
    } else if (level <= 7) {
      return 'Sedang';
    } else {
      return 'Tinggi';
    }
  }
}
