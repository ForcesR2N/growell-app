import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  final currentIndex = 0.obs;
  final isTyping = false.obs;

  void changePage(int index) {
    if (!isTyping.value) {
      currentIndex.value = index;
    }
  }

  void setTyping(bool value) {
    isTyping.value = value;
  }

  void navigateToTab(int index) {
    currentIndex.value = index;
  }

  static const int HOME_TAB = 0;
  static const int DAILY_NUTRITION_TAB = 1;
  static const int PROFILE_TAB = 2;
}
