import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/screens/anasayfa_pages/ana_sayfa.dart';
// import 'package:kangaroom_mobile/screens/anasayfa_pages/ana_sayfa.dart';
import 'package:kangaroom_mobile/screens/login_pages/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Okul Takip Sistemi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const LoginScreen(),
    );
  }
}
  