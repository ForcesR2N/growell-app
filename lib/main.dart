import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:growell_app/pages/login_page.dart';
import 'pages/onboarding/onboarding_questions.dart';
import 'pages/bottom_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('🔥 Firebase successfully connected!');
  } catch (e) {
    print('❌ Firebase connection failed: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Growell App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginPage()
        //  StreamBuilder<User?>(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       // Check if user has completed profile
        //       return FutureBuilder(
        //         future: FirebaseFirestore.instance
        //             .collection('users')
        //             .doc(snapshot.data!.uid)
        //             .collection('profile')
        //             .get(),
        //         builder: (context, profileSnapshot) {
        //           if (profileSnapshot.hasData &&
        //               profileSnapshot.data!.docs.isNotEmpty) {
        //             return const BottomNavigation();
        //           }
        //           return const OnboardingQuestions();
        //        },
        //   );
        //   }
        //   return const OnboardingQuestions();
        // },
        );
  }
}
