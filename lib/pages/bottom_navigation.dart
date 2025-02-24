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

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: currentIndex.value,
            children: [
              HomePage(),
              DailyNutritionPage(),
              ProfilePage(),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: currentIndex.value,
            onTap: (index) => currentIndex.value = index,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.food_bank_outlined),
                activeIcon: Icon(Icons.food_bank),
                label: 'Daily',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          )),
    );
  }
}
