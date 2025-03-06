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
}