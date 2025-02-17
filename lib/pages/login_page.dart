import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growell_app/auth/controllers/auth_controller.dart';
import '../../../widgets/app_values.dart';
import '../../../widgets/custom_button.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Obx(() => Text(
                controller.isLogin.value
                    ? 'Selamat Datang\nKembali!'
                    : 'Mari Mulai\nPerjalanan!',
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )),
              const SizedBox(height: 30),
              Obx(() => TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  errorText: controller.emailError.value.isEmpty 
                      ? null 
                      : controller.emailError.value,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => controller.emailError.value = '',
              )),
              const SizedBox(height: 16),
              Obx(() => TextField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  errorText: controller.passwordError.value.isEmpty 
                      ? null 
                      : controller.passwordError.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
                obscureText: !controller.isPasswordVisible.value,
                onChanged: (_) => controller.passwordError.value = '',
              )),
              const SizedBox(height: 24),
              Obx(() => CustomButton(
                text: controller.isLogin.value ? 'Masuk' : 'Daftar',
                onPressed: () => controller.handleAuth(),
                isLoading: controller.isLoading.value,
              )),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: controller.toggleAuthMode,
                  child: Obx(() => Text(
                    controller.isLogin.value
                        ? 'Belum punya akun? Daftar'
                        : 'Sudah punya akun? Masuk',
                  )),
                ),
              ),
              Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}