import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/login/login.dart';
import 'package:kangaroom_mobile/services/api_service.dart';
import 'package:kangaroom_mobile/config/global_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../anasayfa_pages/ana_sayfa.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> handleLogin(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorDialog(context, "Lütfen kullanıcı adı ve şifrenizi giriniz.");
      return;
    }

    isLoading.value = true;

    try {
      final loginData = await ApiService.login(
        username: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      isLoading.value = false;

      if (loginData != null) {
        // JSON'u modele dönüştür
        final loginResponse = LoginResponse.fromJson(loginData);

        // Kullanıcı bilgisini globalde sakla
        GlobalConfig.personelID = loginResponse.id;
        GlobalConfig.ad = loginResponse.ad;
        GlobalConfig.soyad = loginResponse.soyad;
        GlobalConfig.iletisim = loginResponse.iletisim;

        // personelID'yi shared_preferences'a kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('personelID', loginResponse.id);

        // Ana sayfaya yönlendir
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AnaSayfa()),
        );
      } else {
        _showErrorDialog(context, "Kullanıcı adı veya şifre hatalı!");
      }
    } catch (e) {
      isLoading.value = false;
      _showErrorDialog(context, "Giriş sırasında bir hata oluştu: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Hata"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Tamam"),
              ),
            ],
          ),
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isPasswordVisible.dispose();
    isLoading.dispose();
  }
}
