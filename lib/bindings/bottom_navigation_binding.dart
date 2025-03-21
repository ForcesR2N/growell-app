import 'package:get/get.dart';
import 'package:growell_app/controllers/daily_nutrition_controller.dart';
import 'package:growell_app/controllers/navigation_controller.dart';
import 'package:growell_app/controllers/nutrition_requirement_service.dart';

class BottomNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BottomNavigationController>(BottomNavigationController(), permanent: true);
    Get.put<DailyNutritionController>(DailyNutritionController(), permanent: true);
  }
}
