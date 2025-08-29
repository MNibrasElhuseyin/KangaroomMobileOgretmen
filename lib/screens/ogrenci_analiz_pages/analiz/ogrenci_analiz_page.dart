import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/services/api_service.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_analiz.dart';
import 'package:kangaroom_mobile/widgets/custom_appbar.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';

import 'ogrenci_kart_widget.dart';
import 'ogrenci_analiz_menu_buttons.dart';

class OgrenciAnalizPage extends StatefulWidget {
  const OgrenciAnalizPage({super.key});

  @override
  State<OgrenciAnalizPage> createState() => _OgrenciAnalizPageState();
}

class _OgrenciAnalizPageState extends State<OgrenciAnalizPage> {
  int? selectedIndex;
  List<GetOgrenciAnaliz> ogrenciler = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOgrenciler();
  }

  Future<void> fetchOgrenciler() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await ApiService.getList<GetOgrenciAnaliz>(
        "OgrenciAnaliz",
        (json) => GetOgrenciAnaliz.fromJson(json),
      );
      setState(() => ogrenciler = response);
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      String cleanMessage;
      if (message.contains('Exception: ')) {
        cleanMessage = message.replaceFirst('Exception: ', '');
      } else {
        cleanMessage = message;
      }
      setState(() => errorMessage = cleanMessage);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Öğrenci Analiz'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.redAccent),
                      const SizedBox(height: 12),
                      const Text(
                        'Bağlantı sorunu',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                )
              : selectedIndex == null
                  ? OgrenciKartList(
                      ogrenciler: ogrenciler,
                      onShow: (index) => setState(() => selectedIndex = index),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: OgrenciAnalizMenuButtons(
                            ogrenci: ogrenciler[selectedIndex!],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => setState(() => selectedIndex = null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: Text(
                            "Geri Dön",
                            style: TextStyle(color: AppConstants.accentColor),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
    );
  }
}