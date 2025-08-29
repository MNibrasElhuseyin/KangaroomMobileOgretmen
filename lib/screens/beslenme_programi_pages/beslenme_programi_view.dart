import 'package:flutter/material.dart';
import '../../widgets/app_constant.dart';
import '../../widgets/beslenme_card.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/arama_kutusu.dart';
import '../../widgets/ay_secici.dart';
import 'beslenme_programi_controller.dart';
import 'package:kangaroom_mobile/models/beslenmeProgrami/get_beslenme_programi.dart';

class BeslenmeProgramiView extends StatefulWidget {
  final BeslenmeProgramiController controller;

  const BeslenmeProgramiView({super.key, required this.controller});

  @override
  State<BeslenmeProgramiView> createState() => _BeslenmeProgramiViewState();
}

class _BeslenmeProgramiViewState extends State<BeslenmeProgramiView> {
  String _seciliAy = '';
  String _arama = '';

  @override
  void initState() {
    super.initState();
    widget.controller.fetchBeslenmeProgrami();
  }

  List<GetBeslenmeProgramiModel> get _filtrelenmisKayitlar {
    return widget.controller.kayitlar.value.where((k) {
      final aramaGeciyorMu =
          _arama.isEmpty || k.modelDosyaAdi.toLowerCase().contains(_arama.toLowerCase());
      final ayUygunMu = _seciliAy.isEmpty || k.modelAy == _seciliAy;
      return aramaGeciyorMu && ayUygunMu;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: const CustomAppBar(title: "Beslenme Programı"),
      body: Padding(
        padding: EdgeInsets.all(isWeb ? AppConstants.webPadding : AppConstants.mobilePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AySecici(
              seciliAy: _seciliAy,
              onChanged: (secim) {
                setState(() {
                  _seciliAy = secim ?? '';
                });
              },
              isWeb: isWeb,
            ),
            const SizedBox(height: 16),
            AramaKutusu(
              onChanged: (deger) {
                setState(() {
                  _arama = deger;
                });
              },
              isWeb: isWeb,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: widget.controller.isLoading,
                builder: (context, loading, _) {
                  if (loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ValueListenableBuilder<String?>(
                    valueListenable: widget.controller.error,
                    builder: (context, error, _) {
                      if (error != null) {
                        final message = error;
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

                      final liste = _filtrelenmisKayitlar;
                      if (liste.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: isWeb
                                    ? AppConstants.webIconSize
                                    : AppConstants.mobileIconSize,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Kayıt bulunamadı.",
                                style: TextStyle(
                                  fontSize: isWeb ? 18 : 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: liste.length,
                        itemBuilder: (context, index) {
                          final item = liste[index];
                          return BeslenmeCard(
                            data: {
                              'dosyaAdi': "Beslenme Programı",
                              'tarih': item.modelTarih,
                              'ay': item.modelAy,
                              'hafta': item.modelHafta,
                              'url': item.modelLink,
                            },
                            isWeb: isWeb,
                            index: index,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}