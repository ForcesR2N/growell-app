import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import 'package:growell_app/models/baby_profile_model.dart';
import 'package:growell_app/routes/app_pages.dart';
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

    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: StreamBuilder<BabyProfile?>(
        stream: storageService.getBabyProfile(user?.uid ?? ''),
        builder: (context, snapshot) {
          final babyProfile = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Enhanced Profile Header with gradient
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF91C788), Color(0xFF7EB379)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF91C788).withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
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
                                fontSize: 24,
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: 30,
                              height: 54,
                              child: Image.asset(
                                'assets/images/logo_app.png',
                                fit: BoxFit.contain,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 30),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer circle
                            Container(
                              width: size.width * 0.28,
                              height: size.width * 0.28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            // Inner circle with icon
                            Container(
                              width: size.width * 0.25,
                              height: size.width * 0.25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  babyProfile?.gender == 'male'
                                      ? Icons.face
                                      : Icons.face_3,
                                  size: size.width * 0.12,
                                  color: const Color(0xFF91C788),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.email ?? 'Email tidak tersedia',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Baby Profile Card
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 24),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            spreadRadius: 0,
                            blurRadius: 20,
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
                                padding:
                                    EdgeInsets.all(isSmallScreen ? 10 : 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F3E5),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  babyProfile?.gender == 'male'
                                      ? Icons.child_care
                                      : Icons.child_care,
                                  color: const Color(0xFF91C788),
                                  size: isSmallScreen ? 22 : 26,
                                ),
                              ),
                              SizedBox(width: isSmallScreen ? 12 : 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      babyProfile?.name ?? 'Nama Bayi',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 20 : 22,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                        color: const Color(0xFF2E3E5C),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Baby Profile',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Profile details with enhanced design
                          _buildProfileDetail(
                            icon: Icons.calendar_today,
                            title: 'Usia',
                            value: '${babyProfile?.age ?? 0} bulan',
                            color: const Color(0xFFFFC0C0), // Soft red
                            isSmallScreen: isSmallScreen,
                          ),

                          _buildProfileDetail(
                            icon: Icons.monitor_weight,
                            title: 'Berat',
                            value: '${babyProfile?.weight ?? 0} kg',
                            color: const Color(0xFFFFE9C0), // Soft yellow
                            isSmallScreen: isSmallScreen,
                          ),

                          _buildProfileDetail(
                            icon: babyProfile?.gender == 'male'
                                ? Icons.male
                                : Icons.female,
                            title: 'Jenis Kelamin',
                            value: babyProfile?.gender == 'male'
                                ? 'Laki-laki'
                                : 'Perempuan',
                            color: const Color(0xFFD4E6FE), // Soft blue
                            isSmallScreen: isSmallScreen,
                          ),

                          _buildProfileDetail(
                            icon: Icons.restaurant,
                            title: 'Frekuensi Makan',
                            value: '${babyProfile?.mealsPerDay ?? 0}x sehari',
                            color: const Color(0xFFD4EDDA), // Soft green
                            isSmallScreen: isSmallScreen,
                          ),

                          _buildProfileDetail(
                            icon: Icons.warning_amber_rounded,
                            title: 'Memiliki Alergi',
                            value: babyProfile?.hasAllergy == true
                                ? 'Ya'
                                : 'Tidak',
                            color: const Color(0xFFFDD3E7), // Soft pink
                            isSmallScreen: isSmallScreen,
                          ),

                          _buildProfileDetail(
                            icon: _getActivityIcon(
                                babyProfile?.activityLevel ?? 5),
                            title: 'Tingkat Aktivitas',
                            value: _getActivityLevel(
                                babyProfile?.activityLevel ?? 5),
                            color: const Color(0xFFDDD3FE), // Soft purple
                            isSmallScreen: isSmallScreen,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 24 : 32),

                  // Action buttons with enhanced design
                  Padding(
                    padding: EdgeInsets.only(
                      left: isSmallScreen ? 16 : 24,
                      right: isSmallScreen ? 16 : 24,
                      bottom: padding.bottom + 36,
                    ),
                    child: Column(
                      children: [
                        // Edit Profile Button
                        _buildActionButton(
                          icon: Icons.edit_outlined,
                          title: 'Edit Profile',
                          subtitle: 'Update baby information',
                          iconColor: const Color(0xFFFFB950),
                          bgColor: const Color(0xFFFFF8EE),
                          onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                          isSmallScreen: isSmallScreen,
                        ),

                        SizedBox(height: isSmallScreen ? 16 : 20),

                        // Logout Button
                        _buildActionButton(
                          icon: Icons.logout_rounded,
                          title: 'Keluar',
                          subtitle: 'Sign out from application',
                          iconColor: const Color(0xFFFF5C5C),
                          bgColor: const Color(0xFFFFEEEE),
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
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileDetail({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isSmallScreen,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : (isSmallScreen ? 16 : 20)),
      child: Row(
        children: [
          // Icon in colored circle
          Container(
            width: isSmallScreen ? 40 : 46,
            height: isSmallScreen ? 40 : 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isSmallScreen ? 18 : 20,
            ),
          ),
          SizedBox(width: isSmallScreen ? 12 : 16),
          // Title and value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E3E5C),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return Material(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: isSmallScreen ? 46 : 52,
                height: isSmallScreen ? 46 : 52,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: isSmallScreen ? 22 : 24,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 14 : 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF2E3E5C),
                        fontSize: 17,
                        fontFamily: 'Signika',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontFamily: 'Signika',
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: isSmallScreen ? 16 : 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getActivityIcon(double level) {
    if (level <= 3) {
      return Icons.nightlight_outlined;
    } else if (level <= 7) {
      return Icons.directions_walk;
    } else {
      return Icons.directions_run;
    }
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
