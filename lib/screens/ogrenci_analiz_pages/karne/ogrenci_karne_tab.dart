import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/karne/get_gelisim_list.dart';
import 'package:kangaroom_mobile/widgets/custom_appbar.dart';
import 'package:kangaroom_mobile/screens/ogrenci_analiz_pages/karne/karne_card.dart';
import 'package:kangaroom_mobile/screens/ogrenci_analiz_pages/karne/karne_controller.dart';

class OgrenciKarneTab extends StatefulWidget {
  final int ogrenciID;
  final String ogrenciAdSoyad;
  final String ogrenciSinif;

  const OgrenciKarneTab({
    super.key,
    required this.ogrenciID,
    required this.ogrenciAdSoyad,
    required this.ogrenciSinif,
  });

  @override
  State<OgrenciKarneTab> createState() => _OgrenciKarneTabState();
}

class _OgrenciKarneTabState extends State<OgrenciKarneTab> {
  final KarneController controller = KarneController();

  int? selectedStudentId;
  String selectedDonem = '1. Dönem';
  final List<String> donemler = ['1. Dönem', '2. Dönem'];

  Map<int, String> gelisimTurMap = {};
  Map<int, Map<String, int>> selectedKarnePuanlari = {};

  bool isInitLoading = true;
  String? errorGelisimListMessage;
  String? errorGelisimTurListMessage;

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Future<void> _initLoad() async {
    setState(() {
      isInitLoading = true;
      errorGelisimListMessage = null;
      errorGelisimTurListMessage = null;
    });

    try {
      await controller.fetchGelisimList();
    } catch (e) {
      errorGelisimListMessage = e.toString();
    }

    if (errorGelisimListMessage != null) {
      setState(() {
        isInitLoading = false;
      });
      return;
    }

    try {
      await controller.fetchGelisimTurList();
    } catch (e) {
      errorGelisimTurListMessage = e.toString();
    }

    if (!mounted) return;

    final turList = controller.gelisimTurList.value;
    setState(() {
      gelisimTurMap = {for (var e in turList) e.id: e.ad};
      isInitLoading = false;
    });

    await onStudentChanged(widget.ogrenciID.toString());
  }

  Future<void> onStudentChanged(String? ogrenciIdStr) async {
    if (ogrenciIdStr == null) {
      setState(() {
        selectedStudentId = null;
        selectedKarnePuanlari.clear();
      });
      return;
    }

    int ogrenciId;
    try {
      ogrenciId = int.parse(ogrenciIdStr);
    } catch (_) {
      setState(() {
        selectedStudentId = null;
        selectedKarnePuanlari.clear();
      });
      return;
    }

    setState(() {
      selectedStudentId = ogrenciId;
      selectedKarnePuanlari.clear();
    });

    await controller.fetchKarneByOgrenciId(ogrenciId);

    final karneList = controller.karneList.value;
    final Map<int, Map<String, int>> puanMap = {};
    for (var k in karneList) {
      puanMap.putIfAbsent(k.donem, () => {});
      puanMap[k.donem]![k.gelisimAlani] = k.puan;
    }

    setState(() {
      selectedKarnePuanlari = puanMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Karne'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Öğrenci Bilgisi Kartı
            Container(
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
            ),

            const SizedBox(height: 20),

            // Dönem seçimi (her zaman sabit)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Dönem Seçin',
                border: OutlineInputBorder(),
              ),
              value: selectedDonem,
              items: donemler
                  .map(
                    (donem) => DropdownMenuItem<String>(
                      value: donem,
                      child: Text(donem),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => selectedDonem = v ?? '1. Dönem'),
            ),

            const SizedBox(height: 20),

            // Ana içerik
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isInitLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (errorGelisimListMessage != null) {
                    return Center(
                      child: Text(
                        '$errorGelisimListMessage',
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (errorGelisimTurListMessage != null)
                    return Center(
                      child: Text(
                        'Gelişim türü listesi hatası:\n$errorGelisimTurListMessage',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );

                  if (controller.isLoadingKarneList.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.errorKarneList.value != null) {
                    return Center(
                      child: Text(
                        'Karne verisi hatası: ${controller.errorKarneList.value}',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (selectedStudentId == null) {
                    return const Center(
                      child: Text(
                        'Lütfen devam etmek için öğrenci seçin.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final gelisimAlanlari = gelisimTurMap.entries.toList();
                  int donemInt;
                  try {
                    donemInt = int.parse(selectedDonem[0]);
                  } catch (_) {
                    donemInt = 1;
                  }

                  final puanlar = selectedKarnePuanlari[donemInt] ?? <String, int>{};

                  return ValueListenableBuilder<Map<int, List<GetGelisimListModel>>>(
                    valueListenable: controller.gelisimListMap,
                    builder: (context, gelisimListMap, _) {
                      return ListView.builder(
                        itemCount: gelisimAlanlari.length,
                        itemBuilder: (context, index) {
                          final turId = gelisimAlanlari[index].key;
                          final alanAd = gelisimAlanlari[index].value;
                          final maddeler = gelisimListMap[turId]?.map((e) => e.ad).toList() ?? [];

                          return KarneCard(
                            key: ValueKey(turId),
                            alan: alanAd,
                            maddeler: maddeler,
                            selectedScores: puanlar,
                          );
                        },
                      );
                    },
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