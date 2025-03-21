import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';
import 'package:growell_app/service/error_handling_service.dart';
import 'package:growell_app/service/storage_service.dart';
import 'package:growell_app/service/validation_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ErrorHandlingService(), permanent: true); 
    Get.put(ValidationService(), permanent: true); 
    Get.put(AuthService(), permanent: true);
    Get.put(StorageService(), permanent: true);
  }
}