import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';
import 'etkinlik_onay_controller.dart';
import 'etkinlik_onay_filter_section.dart';
import 'etkinlik_onay_card_list.dart';
import 'package:kangaroom_mobile/models/etkinlikOnay/get_etkinlik_onay.dart';

class EtkinlikOnayView extends StatefulWidget {
  const EtkinlikOnayView({super.key});

  @override
  State<EtkinlikOnayView> createState() => _EtkinlikOnayViewState();
}

class _EtkinlikOnayViewState extends State<EtkinlikOnayView> {
  final controller = EtkinlikOnayController();

  List<GetEtkinlikOnay> _gosterilenListe = [];
  bool isLoading = true;
  String? hataMesaji;
  bool apiHatasi = false; // <-- hata kontrolü için

  @override
  void initState() {
    super.initState();
    controller.seciliDurum = "İzin Verildi";
    _initData();
  }

  Future<void> _initData() async {
    setState(() {
      isLoading = true;
      hataMesaji = null;
      apiHatasi = false;
    });

    try {
      await controller.fetchTumVeriler();

      // İlk API çağrısı başarısızsa, etkinlikListesi boş olur, hata varsay
      if (controller.etkinlikListesi.isEmpty) {
        throw Exception("Etkinlik listesi yüklenemedi");
      }

      _gosterilenListe = controller.tumOnayListesi;
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      String cleanMessage;
      if (message.contains('Exception: ')) {
        cleanMessage = message.replaceFirst('Exception: ', '');
      } else {
        cleanMessage = message;
      }
      hataMesaji = cleanMessage;
      _gosterilenListe = [];
      apiHatasi = true;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onFilterChanged() {
    setState(() {
      _gosterilenListe = controller.filtrele();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Etkinlik Onay"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FilterSection(
              etkinlikler: controller.etkinlikListesi,
              durumlar: controller.durumListesi,
              seciliEtkinlik: controller.seciliEtkinlik,
              seciliDurum: controller.seciliDurum,
              onEtkinlikChanged: (val) {
                controller.seciliEtkinlik = val;
                _onFilterChanged();
              },
              onDurumChanged: (val) {
                controller.seciliDurum = val;
                _onFilterChanged();
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (apiHatasi) {
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
                            hataMesaji ?? "Veri yüklenirken bir hata oluştu.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.etkinlikListesi.isEmpty) {
                    return const Center(
                      child: Text("Etkinlik listesi yüklenemedi."),
                    );
                  }

                  if (controller.seciliEtkinlik == null ||
                      controller.seciliEtkinlik == "") {
                    return const Center(
                      child: Text("Lütfen bir etkinlik seçiniz"),
                    );
                  }

                  if (_gosterilenListe.isEmpty) {
                    return const Center(
                      child: Text("Eşleşen kayıt bulunamadı"),
                    );
                  }

                  return EtkinlikOnayCardList(etkinlikler: _gosterilenListe);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}