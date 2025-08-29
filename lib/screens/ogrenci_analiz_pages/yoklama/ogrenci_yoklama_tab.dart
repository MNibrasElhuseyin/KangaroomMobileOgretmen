import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kangaroom_mobile/widgets/app_constant.dart';
import 'package:kangaroom_mobile/widgets/ay_secici.dart';
import 'package:kangaroom_mobile/widgets/custom_appbar.dart';
import 'package:kangaroom_mobile/widgets/tables/custom_table.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_yoklama.dart';
import 'package:kangaroom_mobile/services/api_service.dart';

class OgrenciYoklamaTab extends StatefulWidget {
  final int ogrenciID;
  final String ogrenciAdSoyad;
  final String ogrenciSinif;

  const OgrenciYoklamaTab({
    super.key,
    required this.ogrenciID,
    required this.ogrenciAdSoyad,
    required this.ogrenciSinif,
  });

  @override
  State<OgrenciYoklamaTab> createState() => _OgrenciYoklamaTabState();
}

class _OgrenciYoklamaTabState extends State<OgrenciYoklamaTab> {
  String _seciliAy = '';
  late Future<List<GetOgrenciYoklamaModel>> _futureYoklama;

  @override
  void initState() {
    super.initState();
    _futureYoklama = ApiService.getList<GetOgrenciYoklamaModel>(
      'OgrenciAnaliz/Yoklama',
      (json) => GetOgrenciYoklamaModel.fromJson(json),
      queryParams: {'id': widget.ogrenciID.toString()},
    );
  }

  int? _monthFromAyAdi(String? ay) {
    if (ay == null || ay.isEmpty) return null;
    final idx = AppConstants.aylar.indexWhere((x) => x.toLowerCase() == ay.toLowerCase());
    return idx == -1 ? null : idx + 1;
  }

  String _formatDate(DateTime dt) {
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year;
    return "$dd.$mm.$yyyy";
  }

  Widget _ogrenciBilgisiCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: Colors.indigo, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ogrenciAdSoyad,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.ogrenciSinif} Sınıfı",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Yoklama'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Öğrenci Bilgisi Kartı
            _ogrenciBilgisiCard(),

            const SizedBox(height: 16),

            AySecici(
              seciliAy: _seciliAy,
              onChanged: (secim) {
                setState(() {
                  _seciliAy = secim ?? '';
                });
              },
              isWeb: kIsWeb,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<GetOgrenciYoklamaModel>>(
                future: _futureYoklama,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    final message = snapshot.error.toString();
                    // Kullanıcıya daha anlaşılır hata mesajı göster
                    String cleanMessage;
                    if (message.contains('Exception: ')) {
                      cleanMessage = message.replaceFirst('Exception: ', '');
                    } else {
                      cleanMessage = message;
                    }
                    return Center(
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
                            cleanMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Veri bulunamadı"));
                  }

                  final data = snapshot.data!;
                  final ayFilter = _monthFromAyAdi(_seciliAy);
                  final filtered = ayFilter == null
                      ? data
                      : data.where((e) => e.tarih.month == ayFilter).toList();

                  final rows = filtered.map((e) {
                    final tarih = _formatDate(e.tarih);
                    final durum = e.modelDurum == "Geldi" ? "Geldi" : "Gelmedi";
                    return [tarih, durum];
                  }).toList();

                  return CustomTable(
                    columnCount: 2,
                    columnHeaders: const ['Tarih', 'Durum'],
                    rowData: rows,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}