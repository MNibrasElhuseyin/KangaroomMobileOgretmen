import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';
import 'etkinlik_controller.dart';
import 'etkinlik_kart.dart';
import 'etkinlik_widgets.dart';

class EtkinlikTanimlamaPage extends StatefulWidget {
  const EtkinlikTanimlamaPage({super.key});

  @override
  State<EtkinlikTanimlamaPage> createState() => _EtkinlikTanimlamaPageState();
}

class _EtkinlikTanimlamaPageState extends State<EtkinlikTanimlamaPage> {
  late final EtkinlikController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EtkinlikController();
  }

  @override
  Widget build(BuildContext context) {
    print(
      'Etkinlik sayısı render ediliyor: ${_controller.eventCount}',
    ); // Hata ayıklam
    return Scaffold(
      appBar: const CustomAppBar(title: "Etkinlik Tanımlama"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                return Column(
                  children: [
                    EtkinlikWidgets.buildDatePicker(_controller, context),
                    const SizedBox(height: 16),
                    EtkinlikWidgets.buildTimePicker(_controller, context),
                    const SizedBox(height: 16),
                    EtkinlikWidgets.buildNameField(_controller),
                    const SizedBox(height: 16),
                    EtkinlikWidgets.buildFeeField(_controller),
                    const SizedBox(height: 16),
                    EtkinlikWidgets.buildFileUploadField(_controller, context),
                    if (_controller.selectedFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Seçilen dosya: ${_controller.selectedFile!.path.split('/').last}",
                        ),
                      ),
                    const SizedBox(height: 16),
                    EtkinlikWidgets.buildSaveButton(_controller, context, () {
                      setState(() {});
                    }),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.deepPurple.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.list, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        'Kayıtlı Etkinlikler (${_controller.eventCount})', // Doğrudan eventCount kullan
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                print(
                  'Kartlar render ediliyor: ${_controller.eventCount}',
                ); // Hata ayıklam
                if (_controller.eventCount == 0) {
                  return Container(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Henüz etkinlik eklenmemiş',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Yukarıdaki formu kullanarak yeni etkinlik ekleyebilirsiniz.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children:
                        _controller.eventCards.map((kart) {
                          return EtkinlikKart(
                            id: kart.id,
                            isim: kart.isim,
                            ucret: kart.ucret,
                            tarih: kart.tarih,
                            saat: kart.saat,
                            dosya: kart.dosya,
                            aciklama: kart.aciklama,
                            resimBinary: kart.resimBinary,
                            resim: kart.resim,
                            isWeb: kart.isWeb,
                            index: kart.index,
                            onDelete: kart.onDelete,
                            onUpdate: kart.onUpdate,
                          );
                        }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
