import 'package:get/get.dart';
import 'package:growell_app/controllers/nutrition_requirement_service.dart';

class DailyNutritionBinding extends Bindings {
  @override
  void dependencies() {
   if (!Get.isRegistered<DailyNutritionController>()) {
      Get.put<DailyNutritionController>(DailyNutritionController(), permanent: true);
    }
  }
}