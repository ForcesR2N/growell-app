import 'package:get/get.dart';
import 'package:growell_app/controllers/daily_nutrition_controller.dart';

class DailyNutritionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DailyNutritionController>(DailyNutritionController(), permanent: true);
  }
}