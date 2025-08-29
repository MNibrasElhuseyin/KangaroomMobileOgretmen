import 'package:flutter/material.dart';
import 'karne_controller.dart';
import 'karne_view.dart';

class KarnePage extends StatelessWidget {
  const KarnePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = KarneController(); // Controller burada oluşturuluyor

    return KarneView(controller: controller); // Eksik olan parametre EKLENDİ
  }
}