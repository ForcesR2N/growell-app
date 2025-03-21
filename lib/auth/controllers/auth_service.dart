import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:growell_app/routes/app_pages.dart';
import 'package:growell_app/service/error_handling_service.dart';
class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ErrorHandlingService _errorHandler = Get.find<ErrorHandlingService>(); 
  final Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    user.bindStream(_auth.authStateChanges());
    ever(user, _handleAuthChanged);
    super.onInit();
  }

  Future<void> _handleAuthChanged(User? user) async {
    if (user == null) {
      Get.offAllNamed(Routes.AUTH);
    } else {
      try {
        final hasProfile = await hasCompletedProfile(user.uid);
        if (hasProfile) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.ONBOARDING);
        }
      } catch (e) {
        // Use error handler
        _errorHandler.handleError(e, fallbackMessage: 'Gagal memverifikasi profil');
        Get.offAllNamed(Routes.ONBOARDING);
      }
    }
  }

  Future<void> _checkUserProfile(String userId) async {
    try {
      final hasProfile = await hasCompletedProfile(userId);
      if (hasProfile) {
        Get.offAndToNamed(Routes.HOME);
      } else {
        Get.offAndToNamed(Routes.ONBOARDING);
      }
    } catch (e) {
      // Use error handler
      _errorHandler.handleError(e, fallbackMessage: 'Gagal memverifikasi profil');
      Get.offAndToNamed(Routes.ONBOARDING);
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e; // Let the calling code handle auth exceptions with the error handler
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login');
    }
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _createUserDocument(userCredential.user!);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e; // Let the calling code handle auth exceptions with the error handler
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mendaftar');
    }
  }

  Future<void> _createUserDocument(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      await user.delete();
      throw Exception('Gagal membuat profil pengguna');
    }
  }

  Future<bool> hasCompletedProfile(String userId) async {
    try {
      final doc = await _firestore.collection('babyProfiles').doc(userId).get();
      return doc.exists;
    } catch (e) {
      _errorHandler.handleError(e, fallbackMessage: 'Gagal memeriksa profil');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _errorHandler.handleError(e, fallbackMessage: 'Gagal keluar dari aplikasi');
      throw Exception('Gagal keluar dari aplikasi');
    }
  }
}