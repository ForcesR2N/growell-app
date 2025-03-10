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
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  late AnimationController _textController;
  late Animation<double> _textAnimation;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

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

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );

    _scaleController.forward();
    _floatController.repeat(reverse: true);
    _textController.forward();

    Timer(const Duration(milliseconds: 2500), () {
      navigateToNextScreen();
    });
  }

  void navigateToNextScreen() {
    if (_hasNavigated) return;

    final authService = Get.find<AuthService>();
    if (authService.user.value != null) {
      _hasNavigated = true;
      Get.offAllNamed(Routes.HOME);
    } else {
      _hasNavigated = true;
      Get.offAllNamed(Routes.AUTH);
    }
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
            ScaleTransition(
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
            const SizedBox(height: 20),
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(_textAnimation),
              child: FadeTransition(
                opacity: _textAnimation,
                child: const Text(
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
          ],
        ),
      ),
    );
  }
}
