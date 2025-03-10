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
      'title': 'Nutrisi Terbaik untuk Si Kecil',
    },
    {
      'image': 'assets/images/slider2.png',
      'title': 'Perkembangan Optimal',
    },
  ];

  final List<Map<String, dynamic>> menuCards = [
    {
      'id': 'ageGroup_0_6',
      'title': 'ASI Eksklusif',
      'subtitle': '0-6 bulan',
      'color': const Color(0xFFFFDED4),
      'icon': Icons.child_care,
      'isActive': true,
    },
    {
      'id': 'ageGroup_6',
      'title': 'Awal MPASI',
      'subtitle': '6 bulan',
      'color': const Color(0xFFD9D4FF),
      'icon': Icons.restaurant,
      'isActive': true,
    },
    {
      'id': 'ageGroup_7_12',
      'title': 'Variasi MPASI',
      'subtitle': '7-12 bulan',
      'color': const Color(0xFFF5C1C1),
      'icon': Icons.set_meal,
      'isActive': true,
    },
    {
      'id': 'ageGroup_13_24',
      'title': 'Makanan Keluarga',
      'subtitle': '13-24 bulan',
      'color': const Color(0xFFC3F5C1),
      'icon': Icons.family_restroom,
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
                        color: menuCards[0]['color'],
                        icon: menuCards[0]['icon'],
                        ageGroupId: menuCards[0]['id'],
                        isActive: menuCards[0]['isActive'],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMenuCard(
                        title: menuCards[1]['title'],
                        color: menuCards[1]['color'],
                        icon: menuCards[1]['icon'],
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
                        color: menuCards[2]['color'],
                        icon: menuCards[2]['icon'],
                        ageGroupId: menuCards[2]['id'],
                        isActive: menuCards[2]['isActive'],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMenuCard(
                        title: menuCards[3]['title'],
                        color: menuCards[3]['color'],
                        icon: menuCards[3]['icon'],
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
            // PageView untuk slide gambar
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

            // Indicator dots
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
        // Placeholder untuk gambar
        // Ganti dengan Image.asset saat memiliki gambar
        Image.asset(
          item['image'],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback jika gambar tidak ada
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

        // Gradient overlay untuk memastikan teks dapat dibaca
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

        // Text content
        Positioned(
          bottom: 30,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Signika',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required String title,
    required Color color,
    required IconData icon,
    required String ageGroupId,
    required bool isActive,
  }) {
    return GestureDetector(
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
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Icon(
                icon,
                size: 48,
                color: const Color(0xFF6F6F6F),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF6F6F6F),
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
          ],
        ),
      ),
    );
  }
}
