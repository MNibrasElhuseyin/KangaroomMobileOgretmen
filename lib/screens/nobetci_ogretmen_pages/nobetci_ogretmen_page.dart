import 'package:flutter/material.dart';
import 'nobetci_ogretmen_controller.dart';
import 'nobetci_ogretmen_view.dart';

class NobetciOgretmenPage extends StatelessWidget {
  const NobetciOgretmenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NobetciOgretmenController();

    return NobetciOgretmenView(controller: controller);
  }
}