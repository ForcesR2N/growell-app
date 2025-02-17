import 'package:get/get.dart';
import 'package:growell_app/controllers/onBoarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}