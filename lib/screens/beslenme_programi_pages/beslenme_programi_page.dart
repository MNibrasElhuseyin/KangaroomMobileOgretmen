import 'package:flutter/material.dart';
import 'beslenme_programi_controller.dart';
import 'beslenme_programi_view.dart';

class BeslenmeProgramiPage extends StatelessWidget {
  const BeslenmeProgramiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BeslenmeProgramiController();

    return BeslenmeProgramiView(controller: controller);
  }
}