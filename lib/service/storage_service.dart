import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:growell_app/models/baby_profile_model.dart';

class StorageService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveBabyProfile(BabyProfile profile) async {
    try {
      await _db.collection('babyProfiles').doc(profile.userId).set(profile.toJson());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Stream<BabyProfile?> getBabyProfile(String userId) {
    return _db.collection('babyProfiles').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return BabyProfile.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    });
  }
}