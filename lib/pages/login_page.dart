import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_controller.dart';
import 'package:growell_app/components/auth_button.dart';
import 'package:growell_app/components/custom_text_field.dart';
import '../../../widgets/app_values.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Logo atau ilustrasi di sini
              Container(
                height: 160,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/Ilustration.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),

              // Welcome Text
              Center(
                child: Column(
                  children: [
                    Obx(() => Text(
                          controller.isLogin.value
                              ? 'Selamat datang kembali!'
                              : 'Mari Mulai',
                          style: const TextStyle(
                            color: Color(0xFF252525),
                            fontSize: 25,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(height: 5),
                    Obx(() => Text(
                          controller.isLogin.value
                              ? 'Silahkan login terlebih dahulu'
                              : 'create your account',
                          style: const TextStyle(
                            color: Color(0xFF252525),
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Email Field

              Obx(() => CustomTextField(
                    controller: controller.emailController,
                    hintText: 'Enter your email',
                    errorText: controller.emailError.value.isEmpty
                        ? null
                        : controller.emailError.value,
                    prefixIcon: Icons.email_outlined,
                    onChanged: (_) => controller.emailError.value = '',
                  )),
              const SizedBox(height: 16),

              // Password Field
              Obx(() => CustomTextField(
                    controller: controller.passwordController,
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    obscureText: !controller.isPasswordVisible.value,
                    errorText: controller.passwordError.value.isEmpty
                        ? null
                        : controller.passwordError.value,
                    onChanged: (_) => controller.passwordError.value = '',
                  )),
              const SizedBox(height: 16),

              // Confirm Password untuk Register
              Obx(() => controller.isLogin.value
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        CustomTextField(
                          controller: controller.confirmPasswordController,
                          hintText: 'Konfirmasi Password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed:
                                controller.toggleConfirmPasswordVisibility,
                          ),
                          obscureText:
                              !controller.isConfirmPasswordVisible.value,
                          errorText:
                              controller.confirmPasswordError.value.isEmpty
                                  ? null
                                  : controller.confirmPasswordError.value,
                          onChanged: (_) =>
                              controller.confirmPasswordError.value = '',
                        ),
                        const SizedBox(height: 16),
                      ],
                    )),

              const SizedBox(height: 40),

              // Login/Register Button
              Obx(() => AuthButton(
                    text: controller.isLogin.value ? 'Login' : 'Register',
                    onPressed: () => controller.handleAuth(),
                    isLoading: controller.isLoading.value,
                  )),

              const SizedBox(height: 20),

              // Toggle Login/Register
              Center(
                child: TextButton(
                  onPressed: controller.toggleAuthMode,
                  child: Obx(() => Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: controller.isLogin.value
                                  ? 'Belum punya akun? '
                                  : 'Sudah punya akun? ',
                              style: const TextStyle(
                                color: Color(0xFF252525),
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text:
                                  controller.isLogin.value ? 'Daftar' : 'Masuk',
                              style: const TextStyle(
                                color: Color(0xFF6C63FF),
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
