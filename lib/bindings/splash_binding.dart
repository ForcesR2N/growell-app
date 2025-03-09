import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
  }
}