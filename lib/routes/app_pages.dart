import 'package:get/get.dart';
import 'package:growell_app/bindings/auth_binding.dart';
import 'package:growell_app/bindings/bottom_navigation_binding.dart';
import 'package:growell_app/bindings/daily_nutrition_binding.dart';
import 'package:growell_app/bindings/edit_profile_binding.dart';
import 'package:growell_app/bindings/onBoarding_binding.dart';
import 'package:growell_app/bindings/splash_binding.dart';
import 'package:growell_app/pages/bottom_navigation.dart';
import 'package:growell_app/pages/daily_nutrition_page.dart';
import 'package:growell_app/pages/edit_profile_page.dart';
import 'package:growell_app/pages/login_page.dart';
import 'package:growell_app/pages/onBoarding_page.dart';
import 'package:growell_app/pages/splash_screen.dart';

abstract class Routes {
  static const SPLASH = '/splash';
  static const INITIAL = AUTH;
  static const AUTH = '/auth';
  static const ONBOARDING = '/onboarding';
  static const HOME = '/home';
  static const DATA_CHECK = '/data-check';
  static const EDIT_PROFILE = '/edit-profile';
  static const DAILY_NUTRITION = '/daily-nutrition';
}

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => LoginPage(),
      binding: AuthBinding(),
      preventDuplicates: true,
      maintainState: true,
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const BottomNavigation(),
      binding: BottomNavigationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfilePage(),
      binding: EditProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
  name: Routes.DAILY_NUTRITION,
  page: () => DailyNutritionPage(),
  binding: DailyNutritionBinding(),
  transition: Transition.rightToLeft,
),
  ];
}
