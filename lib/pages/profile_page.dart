import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import 'package:growell_app/models/baby_profile_model.dart';
import 'package:growell_app/service/storage_service.dart';

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

    // Get screen size
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 54,
                          child: Image.asset(
                            'assets/images/logo_app.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),
                    Container(
                      width: size.width * 0.25, // Responsive width
                      height: size.width * 0.25, // Keep aspect ratio
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: size.width * 0.12, // Responsive icon size
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.email ?? 'Email tidak tersedia',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF272727),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 16 : 24),

              // Baby Profile Section
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 24),
                child: StreamBuilder<BabyProfile?>(
                  stream: storageService.getBabyProfile(user?.uid ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final babyProfile = snapshot.data;

                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  babyProfile?.gender == 'male'
                                      ? Icons.face
                                      : Icons.face_3,
                                  color: Colors.blue,
                                  size: isSmallScreen ? 20 : 24,
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 8 : 12),
                              Expanded(
                                child: Text(
                                  babyProfile?.name ?? 'Nama Bayi',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 18 : 20,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 24),
                          _buildInfoRow(
                            'Usia',
                            '${babyProfile?.age ?? 0} bulan',
                            isSmallScreen,
                          ),
                          _buildInfoRow(
                            'Berat',
                            '${babyProfile?.weight ?? 0} kg',
                            isSmallScreen,
                          ),
                          _buildInfoRow(
                            'Jenis Kelamin',
                            babyProfile?.gender == 'male'
                                ? 'Laki-laki'
                                : 'Perempuan',
                            isSmallScreen,
                          ),
                          _buildInfoRow(
                            'Frekuensi Makan',
                            '${babyProfile?.mealsPerDay ?? 0}x sehari',
                            isSmallScreen,
                          ),
                          _buildInfoRow(
                            'Memiliki Alergi',
                            babyProfile?.hasAllergy == true ? 'Ya' : 'Tidak',
                            isSmallScreen,
                          ),
                          _buildInfoRow(
                            'Tingkat Aktivitas',
                            _getActivityLevel(babyProfile?.activityLevel ?? 5),
                            isSmallScreen,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: isSmallScreen ? 16 : 24),

              // Action Buttons
              Padding(
                padding: EdgeInsets.only(
                  left: isSmallScreen ? 16 : 24,
                  right: isSmallScreen ? 16 : 24,
                  top: isSmallScreen ? 16 : 24,
                  bottom: padding.bottom +
                      36, // Menambahkan padding bottom sesuai dengan safe area
                ),
                child: Column(
                  children: [
                    // Edit Profile Button
                    Container(
                      width: double.infinity,
                      height: isSmallScreen ? 52 : 60,
                      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        shadowColor: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () => Get.toNamed('/edit-profile'),
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: isSmallScreen ? 36 : 42,
                                  height: isSmallScreen ? 36 : 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF8EE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: const Color(0xFFFFB950),
                                      size: isSmallScreen ? 18 : 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 12 : 16),
                                const Expanded(
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Color(0xFF6F6F6F),
                                      fontSize: 16,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: const Color(0xFF6F6F6F),
                                  size: isSmallScreen ? 14 : 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: isSmallScreen ? 52 : 60,
                      child: Material(
                        color: Colors.white,
                        elevation: 1,
                        shadowColor: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () async {
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
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: isSmallScreen ? 36 : 42,
                                  height: isSmallScreen ? 36 : 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEEEE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.logout_rounded,
                                      color: const Color(0xFFFF5C5C),
                                      size: isSmallScreen ? 18 : 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 12 : 16),
                                const Expanded(
                                  child: Text(
                                    'Keluar',
                                    style: TextStyle(
                                      color: Color(0xFF6F6F6F),
                                      fontSize: 16,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: const Color(0xFF6F6F6F),
                                  size: isSmallScreen ? 14 : 16,
                                ),
                              ],
                            ),
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
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
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
