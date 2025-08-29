import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/custom_appbar.dart';
import 'boy_kilo_controller.dart';
import 'boy_kilo_view.dart';

class BoyKiloPage extends StatelessWidget {
  const BoyKiloPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: 'Boy-Kilo'),
      // SizedBox.expand -> BoyKiloView'e sabit ve sınırlı yükseklik veriyor
      body: const SizedBox.expand(child: _BoyKiloViewHost()),
    );
  }
}

/// BoyKiloView içinde Scroll + Sliver kullanıldığı için,
/// const olmayan controller'ı burada üretiyoruz.
class _BoyKiloViewHost extends StatefulWidget {
  const _BoyKiloViewHost();

  @override
  State<_BoyKiloViewHost> createState() => _BoyKiloViewHostState();
}

class _BoyKiloViewHostState extends State<_BoyKiloViewHost> {
  late final BoyKiloController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BoyKiloController();
  }

  @override
  Widget build(BuildContext context) {
    return BoyKiloView(controller: _controller);
  }
}
