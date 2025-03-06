import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/pages/daily_nutrition_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 0.obs;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: currentIndex.value,
            children: [
              HomePage(),
              DailyNutritionPage(),
              ProfilePage(),
            ],
          )),
      bottomNavigationBar: Obx(() => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 24,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      currentIndex.value == 0,
                      Icons.home_outlined,
                      Icons.home_rounded,
                      'Beranda',
                      () => currentIndex.value = 0,
                      isSmallScreen,
                    ),
                    _buildNavItem(
                      currentIndex.value == 1,
                      Icons.restaurant_menu_outlined,
                      Icons.restaurant_menu_rounded,
                      'Daily',
                      () => currentIndex.value = 1,
                      isSmallScreen,
                    ),
                    _buildNavItem(
                      currentIndex.value == 2,
                      Icons.person_outline_rounded,
                      Icons.person_rounded,
                      'Profile',
                      () => currentIndex.value = 2,
                      isSmallScreen,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildNavItem(
      bool isSelected,
      IconData inactiveIcon,
      IconData activeIcon,
      String label,
      VoidCallback onTap,
      bool isSmallScreen) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF91C788).withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected
                  ? const Color(0xFF91C788)
                  : const Color(0xFF6F6F6F),
              size: isSmallScreen ? 24 : 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF91C788)
                    : const Color(0xFF6F6F6F),
                fontSize: isSmallScreen ? 12 : 14,
                fontFamily: 'Signika',
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
