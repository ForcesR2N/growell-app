import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import 'package:growell_app/service/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
    Get.put(StorageService(), permanent: true);
  }
}
