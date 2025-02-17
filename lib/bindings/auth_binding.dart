import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_controller.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}
