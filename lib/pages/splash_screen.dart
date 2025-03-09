// lib/pages/splash_screen.dart - Versi dengan Animasi Floating
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:growell_app/routes/app_pages.dart';
import 'package:growell_app/auth/controllers/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controller untuk animasi muncul (fade in + scale)
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Controller untuk animasi melayang
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Controller untuk animasi teks
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi masuk
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    // Animasi melayang
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    // Animasi teks
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );

    // Jalankan animasi
    _scaleController.forward();

    Future.delayed(const Duration(milliseconds: 600), () {
      _floatController.repeat(reverse: true);
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      _textController.forward();
    });

    // Navigasi ke halaman berikutnya
    Timer(const Duration(seconds: 3), () {
      final authService = Get.find<AuthService>();
      if (authService.user.value != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.AUTH);
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _floatController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF91C788),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Image.asset(
                          'assets/images/logo_app.png',
                          width: 180,
                          height: 180,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(_textAnimation),
              child: FadeTransition(
                opacity: _textAnimation,
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 50.0),
                  child: Text(
                    'GroWell',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
