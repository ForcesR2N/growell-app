import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/controllers/navigation_controller.dart';
import 'package:growell_app/pages/daily_nutrition_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomNavigationController controller = Get.find<BottomNavigationController>();

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              HomePage(),
              DailyNutritionPage(),
              ProfilePage(),
            ],
          )),
      bottomNavigationBar: Obx(() => Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                elevation: 0,
                currentIndex: controller.currentIndex.value,
                onTap: (index) => controller.changePage(index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home, size: 28),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.food_bank_outlined),
                    activeIcon: Icon(Icons.food_bank, size: 28),
                    label: 'Daily',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person, size: 28),
                    label: 'Profile',
                  ),
                ],
                selectedItemColor: Color(0xFF91C788),
                unselectedItemColor: Colors.grey,
                selectedFontSize: 14,
                unselectedFontSize: 12,
              ),
            ),
          )),
    );
  }
}