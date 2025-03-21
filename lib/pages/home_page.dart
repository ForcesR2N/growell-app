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

  final PageController _sliderController = PageController();
  int _currentPage = 0;
  final List<Map<String, dynamic>> _sliderItems = [
    {
      'image': 'assets/images/slider1.png',
    },
    {
      'image': 'assets/images/slider2.png',
    },
  ];

  // Enhanced menu cards with gradient colors and more appealing designs
  final List<Map<String, dynamic>> menuCards = [
    {
      'id': 'ageGroup_0_6',
      'title': 'ASI Eksklusif',
      'subtitle': '0-6 bulan',
      'gradientColors': [
        Color(0xFFFFD3BA),
        Color(0xFFFFB199)
      ], // Soft orange gradient
      'icon': Icons.child_care,
      'iconColor': Color(0xFFF57C00), // Deep orange for icon
      'isActive': true,
    },
    {
      'id': 'ageGroup_6',
      'title': 'Awal MPASI',
      'subtitle': '6 bulan',
      'gradientColors': [
        Color(0xFFD4E6FE),
        Color(0xFFB3C7FF)
      ], // Soft blue gradient
      'icon': Icons.restaurant,
      'iconColor': Color(0xFF3F51B5), // Indigo for icon
      'isActive': true,
    },
    {
      'id': 'ageGroup_7_12',
      'title': 'Variasi MPASI',
      'subtitle': '7-12 bulan',
      'gradientColors': [
        Color(0xFFFDD3E7),
        Color(0xFFF48FB1)
      ], // Soft pink gradient
      'icon': Icons.set_meal,
      'iconColor': Color(0xFFE91E63), // Pink for icon
      'isActive': true,
    },
    {
      'id': 'ageGroup_13_24',
      'title': 'Makanan Keluarga',
      'subtitle': '13-24 bulan',
      'gradientColors': [
        Color(0xFFD4EDDA),
        Color(0xFFA3D9B0)
      ], // Soft green gradient
      'icon': Icons.family_restroom,
      'iconColor': Color(0xFF2E7D32), // Green for icon
      'isActive': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _sliderController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (_currentPage < _sliderItems.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        if (_sliderController.hasClients) {
          _sliderController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }

        _startAutoSlide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final cardHeight = isSmallScreen ? 160.0 : 200.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Hello $babyName,\n',
                                style: const TextStyle(
                                  color: Color(0xFF91C788),
                                  fontSize: 25,
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.w600,
                                  height: 1.12,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              const TextSpan(
                                text: 'Pilih Panduan Makanan',
                                style: TextStyle(
                                  color: Color(0xFF7B7B7B),
                                  fontSize: 18,
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.w400,
                                  height: 1.56,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 54,
                        margin: const EdgeInsets.only(left: 16),
                        child: Image.asset(
                          'assets/images/logo_app.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildImageSlider(),
              const SizedBox(height: 24),
              SizedBox(
                height: cardHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMenuCard(
                        title: menuCards[0]['title'],
                        subtitle: menuCards[0]['subtitle'],
                        gradientColors: menuCards[0]['gradientColors'],
                        icon: menuCards[0]['icon'],
                        iconColor: menuCards[0]['iconColor'],
                        ageGroupId: menuCards[0]['id'],
                        isActive: menuCards[0]['isActive'],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMenuCard(
                        title: menuCards[1]['title'],
                        subtitle: menuCards[1]['subtitle'],
                        gradientColors: menuCards[1]['gradientColors'],
                        icon: menuCards[1]['icon'],
                        iconColor: menuCards[1]['iconColor'],
                        ageGroupId: menuCards[1]['id'],
                        isActive: menuCards[1]['isActive'],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: cardHeight,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMenuCard(
                        title: menuCards[2]['title'],
                        subtitle: menuCards[2]['subtitle'],
                        gradientColors: menuCards[2]['gradientColors'],
                        icon: menuCards[2]['icon'],
                        iconColor: menuCards[2]['iconColor'],
                        ageGroupId: menuCards[2]['id'],
                        isActive: menuCards[2]['isActive'],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMenuCard(
                        title: menuCards[3]['title'],
                        subtitle: menuCards[3]['subtitle'],
                        gradientColors: menuCards[3]['gradientColors'],
                        icon: menuCards[3]['icon'],
                        iconColor: menuCards[3]['iconColor'],
                        ageGroupId: menuCards[3]['id'],
                        isActive: menuCards[3]['isActive'],
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

  Widget _buildImageSlider() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            PageView.builder(
              controller: _sliderController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _sliderItems.length,
              itemBuilder: (context, index) {
                return _buildSliderItem(_sliderItems[index]);
              },
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _sliderItems.length,
                  (index) => Container(
                    width: index == _currentPage ? 16 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? const Color(0xFF91C788)
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderItem(Map<String, dynamic> item) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          item['image'],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFEEF6ED),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Color(0xFF91C788),
                ),
              ),
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
              stops: const [0.6, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required IconData icon,
    required Color iconColor,
    required String ageGroupId,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        if (isActive) {
          Get.to(
            () => FoodRecommendationPage(
              ageGroup: ageGroupId,
              title: '',
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                    height: 1.12,
                    letterSpacing: -0.50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF181D20),
                  fontSize: 12,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
