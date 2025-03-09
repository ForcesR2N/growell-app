import 'package:get/get.dart';
import 'package:growell_app/controllers/nutrition_requirement_service.dart';

class BottomNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyNutritionController>(() => DailyNutritionController());
  }
}
