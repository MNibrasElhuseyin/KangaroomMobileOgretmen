import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/karne/get_gelisim_list.dart';
import 'package:kangaroom_mobile/models/karne/get_karne.dart';
import 'package:kangaroom_mobile/models/karne/get_ogrenci_list.dart';
import 'package:kangaroom_mobile/models/karne/post_karne.dart';
import 'package:kangaroom_mobile/widgets/custom_appbar.dart';
import 'package:kangaroom_mobile/widgets/karne_card.dart';
import 'karne_controller.dart';

class KarneView extends StatefulWidget {
  final KarneController controller;

  const KarneView({super.key, required this.controller});

  @override
  State<KarneView> createState() => _KarneViewState();
}

class _KarneViewState extends State<KarneView> {
  String? selectedStudentId;
  String selectedDonem = '1. Dönem';
  bool hasUnsavedChanges = false;
  bool isSaving = false;
  bool isLoading = true;
  String? errorMessage;

  final List<String> donemler = ['1. Dönem', '2. Dönem'];

  Map<int, String> gelisimTurMap = {};
  Map<int, Map<String, int>> selectedKarnePuanlari = {};
  Map<int, Map<String, String?>> modifiedKarnePuanlari = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await widget.controller.fetchAll();
      final turList = widget.controller.gelisimTurList.value;

      setState(() {
        gelisimTurMap = {for (var e in turList) e.id: e.ad};
        selectedStudentId = null;
        isLoading = false;
      });
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      String cleanMessage;
      if (message.contains('Exception: ')) {
        cleanMessage = message.replaceFirst('Exception: ', '');
      } else {
        cleanMessage = message;
      }
      setState(() {
        errorMessage = cleanMessage;
        isLoading = false;
      });
    }
  }

  Future<void> onStudentChanged(String? ogrenciIdStr) async {
    if (ogrenciIdStr == null) {
      setState(() {
        selectedStudentId = null;
        selectedKarnePuanlari.clear();
        modifiedKarnePuanlari.clear();
        hasUnsavedChanges = false;
      });
      return;
    }

    int ogrenciId;
    try {
      ogrenciId = int.parse(ogrenciIdStr);
    } catch (e) {
      setState(() {
        selectedStudentId = null;
        selectedKarnePuanlari.clear();
        modifiedKarnePuanlari.clear();
        hasUnsavedChanges = false;
      });
      return;
    }

    setState(() {
      selectedStudentId = ogrenciIdStr;
      selectedKarnePuanlari.clear();
      modifiedKarnePuanlari.clear();
      hasUnsavedChanges = false;
    });

    try {
      await widget.controller.fetchKarneByOgrenciId(ogrenciId);
      final karneList = widget.controller.karneList.value;

      Map<int, Map<String, int>> puanMap = {};
      for (var karne in karneList) {
        puanMap.putIfAbsent(karne.donem, () => {});
        puanMap[karne.donem]![karne.gelisimAlani] = karne.puan;
      }

      setState(() {
        selectedKarnePuanlari = puanMap;
        modifiedKarnePuanlari.clear();
        hasUnsavedChanges = false;
      });
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      String cleanMessage;
      if (message.contains('Exception: ')) {
        cleanMessage = message.replaceFirst('Exception: ', '');
      } else {
        cleanMessage = message;
      }
      setState(() {
        errorMessage = 'Karne verileri alınamadı: $cleanMessage';
      });
    }
  }

  void onScoreChanged(int donem, String madde, String? label) {
    final donemMap = Map<String, String?>.from(
      modifiedKarnePuanlari[donem] ?? {},
    );

    if (label == null) {
      donemMap.remove(madde);
    } else {
      donemMap[madde] = label;
    }

    modifiedKarnePuanlari[donem] = donemMap;

    bool anyChange = false;
    modifiedKarnePuanlari.forEach((donemKey, map) {
      map.forEach((maddeKey, selectedLabel) {
        final originalPuan = selectedKarnePuanlari[donemKey]?[maddeKey];
        final originalLabel = _puanToLabel(originalPuan);
        if (selectedLabel != originalLabel) {
          anyChange = true;
        }
      });
    });

    if (anyChange != hasUnsavedChanges) {
      setState(() {
        hasUnsavedChanges = anyChange;
      });
    } else {
      setState(() {});
    }
  }

  String? _puanToLabel(int? puan) {
    switch (puan) {
      case 1:
        return 'Yetersiz';
      case 2:
        return 'Normal';
      case 3:
        return 'İyi';
      case 4:
        return 'Çok İyi';
      default:
        return null;
    }
  }

  int? _labelToPuan(String? label) {
    switch (label) {
      case 'Yetersiz':
        return 1;
      case 'Normal':
        return 2;
      case 'İyi':
        return 3;
      case 'Çok İyi':
        return 4;
      default:
        return null;
    }
  }

  Future<void> _saveChanges() async {
    if (selectedStudentId == null) return;

    setState(() {
      isSaving = true;
    });

    final ogrenciId = int.parse(selectedStudentId!);
    final donemInt = int.tryParse(selectedDonem[0]) ?? 1;

    final entries = modifiedKarnePuanlari[donemInt]?.entries;
    if (entries == null || entries.isEmpty) {
      setState(() => isSaving = false);
      return;
    }

    List<PostKarne> postModels = [];

    for (final entry in entries) {
      final gelisimAlaniAd = entry.key;
      final yeniLabel = entry.value;
      final yeniPuan = _labelToPuan(yeniLabel);
      if (yeniPuan == null) continue;

      final gelisimItem = widget.controller.gelisimList.value.firstWhere(
        (element) => element.ad == gelisimAlaniAd,
        orElse: () => GetGelisimListModel(id: -1, tur: -1, ad: ''),
      );

      if (gelisimItem.id == -1) {
        print('⚠️ Gelişim alanı bulunamadı: $gelisimAlaniAd');
        continue;
      }

      GetKarne? existing;
      try {
        existing = widget.controller.karneList.value.firstWhere(
          (e) => e.donem == donemInt && e.gelisimAlani == gelisimAlaniAd,
        );
      } catch (e) {
        existing = null;
      }

      postModels.add(
        PostKarne(
          id: existing?.id,
          puan: yeniPuan,
          ogrenciId: ogrenciId,
          gelisimId: gelisimItem.id,
          donem: donemInt,
        ),
      );
    }

    if (postModels.isEmpty) {
      setState(() => isSaving = false);
      return;
    }

    bool result = await widget.controller.postKarneBatch(postModels);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade600,
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Tüm değişiklikler başarıyla kaydedildi.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );

      await widget.controller.fetchKarneByOgrenciId(ogrenciId);

      final karneList = widget.controller.karneList.value;
      Map<int, Map<String, int>> puanMap = {};
      for (var karne in karneList) {
        puanMap.putIfAbsent(karne.donem, () => {});
        puanMap[karne.donem]![karne.gelisimAlani] = karne.puan;
      }

      setState(() {
        selectedKarnePuanlari = puanMap;
        modifiedKarnePuanlari.clear();
        hasUnsavedChanges = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade600,
          content: Row(
            children: const [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Bazı değişiklikler kaydedilemedi.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gelişim Raporu'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ValueListenableBuilder<List<GetOgrenciListModel>>(
              valueListenable: widget.controller.ogrenciList,
              builder: (context, ogrenciler, _) {
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Öğrenci Seçin',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedStudentId,
                  hint: const Text('Öğrenci Seçin'),
                  items: ogrenciler
                      .map(
                        (ogr) => DropdownMenuItem<String>(
                          value: ogr.id.toString(),
                          child: Text('${ogr.ad} ${ogr.soyad}'),
                        ),
                      )
                      .toList(),
                  onChanged: onStudentChanged,
                );
              },
            ),
            const SizedBox(height: 16),
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
              onChanged: (value) {
                setState(() {
                  selectedDonem = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: isSaving
                    ? const Center(
                        key: ValueKey('loading'),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : ElevatedButton.icon(
                        key: const ValueKey('button'),
                        onPressed: hasUnsavedChanges ? _saveChanges : null,
                        icon: const Icon(Icons.save),
                        label: const Text("Kaydet"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hasUnsavedChanges
                              ? Colors.blue.shade700
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
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
                      : selectedStudentId == null
                          ? const Center(
                              child: Text(
                                  'Lütfen devam etmek için öğrenci seçin.'),
                            )
                          : ValueListenableBuilder<
                              Map<int, List<GetGelisimListModel>>>(
                              valueListenable:
                                  widget.controller.gelisimListMap,
                              builder: (context, gelisimListMap, _) {
                                final gelisimAlanlari =
                                    gelisimTurMap.entries.toList();

                                return ListView.builder(
                                  itemCount: gelisimAlanlari.length,
                                  itemBuilder: (context, index) {
                                    final turId =
                                        gelisimAlanlari[index].key;
                                    final alanAd =
                                        gelisimAlanlari[index].value;
                                    final maddeler =
                                        gelisimListMap[turId]
                                                ?.map((e) => e.ad)
                                                .toList() ??
                                            [];

                                    int donemInt =
                                        int.tryParse(selectedDonem[0]) ?? 1;
                                    final puanlar =
                                        selectedKarnePuanlari[donemInt] ?? {};
                                    final modifiedMap =
                                        modifiedKarnePuanlari[donemInt] ?? {};

                                    final Map<String, String> combinedScores =
                                        {};
                                    final Map<String, String> apiScores = {};

                                    for (var madde in maddeler) {
                                      final originalLabel =
                                          _puanToLabel(puanlar[madde]) ?? '';
                                      final modifiedLabel = modifiedMap[madde];
                                      combinedScores[madde] =
                                          modifiedLabel ?? originalLabel;
                                      apiScores[madde] = originalLabel;
                                    }

                                    return KarneCard(
                                      key: ValueKey(turId),
                                      alan: alanAd,
                                      maddeler: maddeler,
                                      selectedScores: combinedScores,
                                      apiScores: apiScores,
                                      onChanged: (madde, label) {
                                        onScoreChanged(
                                            donemInt, madde, label);
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
