import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:growell_app/models/baby_profile_model.dart';
import 'package:growell_app/service/error_handling_service.dart';

class StorageService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ErrorHandlingService _errorHandler = Get.find<ErrorHandlingService>(); // Add this line

  Future<void> saveBabyProfile(BabyProfile profile) async {
    try {
      await _db.collection('babyProfiles').doc(profile.userId).set(profile.toJson());
      _errorHandler.showSuccessSnackbar(
        'Sukses',
        'Profil bayi berhasil disimpan',
      );
    } catch (e) {
      _errorHandler.handleError(e, fallbackMessage: 'Gagal menyimpan profil bayi');
      throw e; // Rethrow for the calling code to handle if needed
    }
  }

  Stream<BabyProfile?> getBabyProfile(String userId) {
    try {
      return _db.collection('babyProfiles').doc(userId).snapshots().map((doc) {
        if (doc.exists) {
          return BabyProfile.fromJson({...doc.data()!, 'id': doc.id});
        }
        return null;
      });
    } catch (e) {
      _errorHandler.handleError(e, fallbackMessage: 'Gagal memuat profil bayi');
      return Stream.value(null); // Return an empty stream
    }
  }
}