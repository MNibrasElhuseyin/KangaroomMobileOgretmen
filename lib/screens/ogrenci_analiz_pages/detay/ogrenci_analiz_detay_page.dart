import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/custom_appbar.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_detay.dart';
import 'package:kangaroom_mobile/services/api_service.dart';
import 'package:kangaroom_mobile/screens/ogrenci_analiz_pages/detay/ogrenci_detay_textbox_widget.dart';

class OgrenciAnalizDetayPage extends StatefulWidget {
  final int ogrenciId;

  const OgrenciAnalizDetayPage({super.key, required this.ogrenciId});

  @override
  State<OgrenciAnalizDetayPage> createState() => _OgrenciAnalizDetayPageState();
}

class _OgrenciAnalizDetayPageState extends State<OgrenciAnalizDetayPage> {
  late Future<GetOgrenciDetayModel?> _futureOgrenciDetay;

  @override
  void initState() {
    super.initState();
    _futureOgrenciDetay = _fetchOgrenciDetay();
  }

  Future<GetOgrenciDetayModel?> _fetchOgrenciDetay() async {
    try {
      final liste = await ApiService.getList<GetOgrenciDetayModel>(
        'OgrenciAnaliz/Detay',
        (json) => GetOgrenciDetayModel.fromJson(json),
        queryParams: {'id': widget.ogrenciId.toString()},
      );
      if (liste.isNotEmpty) {
        return liste.first;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('📶 İnternet bağlantınızı kontrol ediniz');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detay'),
      body: FutureBuilder<GetOgrenciDetayModel?>(
        future: _futureOgrenciDetay,
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
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Veri bulunamadı'));
          }

          final ogrenci = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                OgrenciDetayTextBox("TC", ogrenci.modelTC),
                OgrenciDetayTextBox("Adı Soyadı", '${ogrenci.modelAd} ${ogrenci.modelSoyad}'),
                OgrenciDetayTextBox("Doğum Tarihi", ogrenci.modelDogumTarih),
                OgrenciDetayTextBox("Anne Adı", ogrenci.modelAnneAd),
                OgrenciDetayTextBox("Baba Adı", ogrenci.modelBabaAd),
                OgrenciDetayTextBox("Teslim Alacak Diğer Kişi Adı", ogrenci.modelTeslimAlacakad),
                OgrenciDetayTextBox("Kullandığı İlaç", ogrenci.modelIlacAd),
                OgrenciDetayTextBox("İlaç Saati", ogrenci.modelIlacSaat),
                OgrenciDetayTextBox("Sınıfı", ogrenci.modelSinif),
                OgrenciDetayTextBox("Hastalık", ogrenci.modelHastalik),
                OgrenciDetayTextBox("Alerji", ogrenci.modelAlerji),
              ],
            ),
          );
        },
      ),
    );
  }
}