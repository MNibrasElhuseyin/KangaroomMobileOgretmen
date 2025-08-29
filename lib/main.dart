import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kangaroom_mobile/screens/anasayfa_pages/ana_sayfa.dart';
import 'package:kangaroom_mobile/screens/login_pages/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    // personelID 0'dan büyükse giriş yapılmış kabul edilir
    return (prefs.getInt('personelID') ?? 0) > 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Okul Takip Sistemi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == true) {
            return const AnaSayfa();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
