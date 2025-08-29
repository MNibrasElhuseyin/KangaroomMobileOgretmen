import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/screens/sinif_takip_pages/sinif_takip_controller.dart';
import 'package:kangaroom_mobile/screens/sinif_takip_pages/sinif_takip_view.dart';
import '../../widgets/custom_appbar.dart';

class SinifTakipPage extends StatefulWidget {
  const SinifTakipPage({super.key});

  @override
  _SinifTakipPageState createState() => _SinifTakipPageState();
}

class _SinifTakipPageState extends State<SinifTakipPage> {
  final _controller = SinifTakipController();

  @override
  void initState() {
    super.initState();
  }

  void _onMenuItemSelected(int index) {
    setState(() {
      _controller.setSelectedMenuItem(index);
      _controller.resetPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Sınıf Takip"),
      body: SinifTakipView(
        controller: _controller,
        onMenuItemSelected: _onMenuItemSelected,
      ),
    );
  }
}
