import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../components/app_text_style.dart';
import 'login_controller.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Üst dalga
          Positioned(
            top: 0,
            child: Opacity(
              opacity: 0.7,
              child: SvgPicture.asset(
                "assets/images/wave_purple_up.svg",
                width: screenWidth,
              ),
            ),
          ),
          // Alt dalga
          Positioned(
            bottom: 0,
            child: Opacity(
              opacity: 0.1,
              child: SvgPicture.asset(
                "assets/images/wave-grey_down.svg",
                width: screenWidth,
              ),
            ),
          ),

          // Giriş içeriği
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: isMobile ? 120 : 180),
                  Image.asset(
                    "assets/images/Kangaroom.png",
                    height: isMobile ? 100 : 140,
                  ),
                  const SizedBox(height: 32),

                  // Giriş kutusu
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.all(20),
                    width: isMobile ? screenWidth * 0.9 : 400,
                    decoration: BoxDecoration(
                      color: const Color(0xffF3F3F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Kullanıcı adı alanı
                        RoundedInputField(
                          controller: controller.emailController,
                          isEmail: false,
                          isPassword: false,
                          hintText: "Kullanıcı adı", // türkçe karakter destekli
                          icon: Icons.person,
                          onChange: (_) {},
                        ),
                        const SizedBox(height: 12),

                        // Şifre alanı
                        ValueListenableBuilder<bool>(
                          valueListenable: controller.isPasswordVisible,
                          builder: (context, isVisible, _) {
                            return RoundedInputField(
                              controller: controller.passwordController,
                              isEmail: false,
                              isPassword: true,
                              hintText: "Şifre", // türkçe karakter destekli
                              icon: Icons.lock,
                              isPasswordVisible: isVisible,
                              togglePasswordVisibility: controller.togglePasswordVisibility,
                              onChange: (_) {},
                            );
                          },
                        ),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Şifremi unuttum", // türkçe çevirdim
                            style: AppTextStyle.MINI_BOLD_DESCRIPTION_TEXT,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Login butonu
                        ValueListenableBuilder<bool>(
                          valueListenable: controller.isLoading,
                          builder: (context, isLoading, _) {
                            return RoundedButton(
                              text: isLoading ? "YÜKLENİYOR..." : "GİRİŞ", // türkçe karakter destekli
                              press: isLoading
                                  ? null
                                  : () async {
                                      await controller.handleLogin(context);
                                    },
                              color: const Color(0xFF3F3D56),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}