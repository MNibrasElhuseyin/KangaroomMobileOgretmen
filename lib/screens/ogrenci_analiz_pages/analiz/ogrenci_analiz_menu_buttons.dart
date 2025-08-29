import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_analiz.dart';

import '../detay/ogrenci_analiz_detay_page.dart';
import '../karne/ogrenci_karne_tab.dart';
import '../yoklama/ogrenci_yoklama_tab.dart';
import 'package:kangaroom_mobile/screens/ogrenci_analiz_pages/boy_kilo_analiz/boy_kilo_analiz_page.dart';

class OgrenciAnalizMenuButtons extends StatelessWidget {
  final GetOgrenciAnaliz ogrenci;

  const OgrenciAnalizMenuButtons({super.key, required this.ogrenci});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 👤 Öğrenci Bilgisi Kartı
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.shade100),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.person_outline, size: 28, color: Colors.indigo),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ogrenci.adSoyad,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${ogrenci.sinif} Sınıfı",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Menü Butonları
        _buildTabButton(context, "Detay", Icons.info_outline, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OgrenciAnalizDetayPage(ogrenciId: ogrenci.id),
            ),
          );
        }),
        _buildTabButton(context, "Yoklama", Icons.calendar_today, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OgrenciYoklamaTab(ogrenciID: ogrenci.id, ogrenciAdSoyad: ogrenci.adSoyad, ogrenciSinif: ogrenci.sinif),
            ),
          );
        }),
        _buildTabButton(context, "Karne", Icons.school, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OgrenciKarneTab(ogrenciID: ogrenci.id, ogrenciAdSoyad: ogrenci.adSoyad, ogrenciSinif: ogrenci.sinif,),
            ),
          );
        }),
        _buildTabButton(context, "Boy Kilo Analiz", Icons.monitor_weight, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BoyKiloAnalizPage(ogrenciID: ogrenci.id, ogrenci: ogrenci,),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTabButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: AppConstants.accentColor),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}