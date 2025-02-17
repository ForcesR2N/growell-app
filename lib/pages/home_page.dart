import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/pages/food_recommendation_page.dart';
import 'package:growell_app/widgets/app_values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = Get.find();

  final List<Map<String, dynamic>> menuCards = [
    {
      'id': 'ageGroup_0_6', 
      'title': 'ASI Eksklusif',
      'subtitle': '0-6 bulan',
      'gradient': const [Color(0xFFFF9966), Color(0xFFFF5E62)],
      'icon': Icons.child_care,
      'isActive': true,
    },
    {
      'id': 'ageGroup_6',   
      'title': 'Awal MPASI',
      'subtitle': '6 bulan',
      'gradient': const [Color(0xFF4E65FF), Color(0xFF92EFFD)],
      'icon': Icons.restaurant,
      'isActive': true,
    },
    {
      'id': 'ageGroup_7_12', 
      'title': 'Variasi MPASI',
      'subtitle': '7-12 bulan',
      'gradient': const [Color(0xFF736EFE), Color(0xFF62E4EC)],
      'icon': Icons.set_meal,
      'isActive': true,
    },
    {
      'id': 'ageGroup_13_24', 
      'title': 'Makanan Keluarga',
      'subtitle': '13-24 bulan',
      'gradient': const [Color(0xFFFF6B95), Color(0xFFFF5ED3)],
      'icon': Icons.family_restroom,
      'isActive': true,
    },
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B35),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppValues.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('babyProfiles')
                      .doc(_authService.user.value?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final babyName = snapshot.data?.get('name') ?? '';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          babyName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Pilih Panduan Makanan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

            ...menuCards.map((card) => _buildMenuCard(
                      title: card['title'],
                      subtitle: card['subtitle'],
                      gradient: card['gradient'],
                      icon: card['icon'],
                      ageGroupId: card['id'],
                      isActive: card['isActive'],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required IconData icon,
    required String ageGroupId,
    required bool isActive,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          if (isActive) {
            Get.to(
              () => FoodRecommendationPage(
                ageGroup: ageGroupId,
                title: title,
              ),
              transition: Transition.rightToLeft,
            );
          } else {
            Get.snackbar(
              'Info',
              'Fitur ini akan segera hadir',
              backgroundColor: Colors.blue,
              colorText: Colors.white,
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  if (!isActive)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Segera Hadir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
