// ===============================
// file: lib/pages/ogrenci_takip/ogrenci_takip_page.dart
// ===============================
import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/ogrenciTakip/post_ogrenci_yoklama.dart';
import 'package:kangaroom_mobile/models/ogrenciTakip/post_ogrenci_beslenme.dart';
import 'package:kangaroom_mobile/models/ogrenciTakip/post_ogrenci_uyku.dart';
import 'package:kangaroom_mobile/models/ogrenciTakip/post_ogrenci_duygu_durum.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/date_widget.dart';
import 'uyku_container.dart';
import 'duygu_durumu_container.dart';
import 'yemek_container.dart';
import 'yoklama_container.dart';

import 'ogrenci_takip_controller.dart';

class OgrenciTakipPage extends StatefulWidget {
  const OgrenciTakipPage({super.key});

  @override
  State<OgrenciTakipPage> createState() => _OgrenciTakipPageState();
}

class _OgrenciTakipPageState extends State<OgrenciTakipPage> {
  late final OgrenciTakipController controller;

  String? selectedOgrenciId;
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  bool? isYoklamaGeldi;

  // Yemek verileri - UI key'leriyle tutuyoruz
  Map<String, String?> mealDataUI = {
    'Kahvaltı': null,
    'Öğle Yemeği': null,
    'İkindi Yemeği': null,
  };

  // Backend key'leriyle de erişim sağlamak için
  Map<String, String?> get mealDataBackend {
    return {
      'kahvalti': mealDataUI['Kahvaltı'],
      'ogle': mealDataUI['Öğle Yemeği'],
      'ikindi': mealDataUI['İkindi Yemeği'],
    };
  }

  String? moodData;                        // YEŞİL baseline – duygu
  String? sleepData;                       // YEŞİL baseline – uyku

  // Geçici seçimler (MAVİ)
  String? currentMood;                     // duygu seçimi
  String? currentSleep;                    // uyku seçimi

  // Kaydet tetikleyicileri (toggle) - her container için ayrı
  bool mealSaved = false;
  bool moodSaved = false;
  bool sleepSaved = false;

  // Baseline kaynak bayrakları
  bool isMoodBaselineFromApi = false;
  bool isSleepBaselineFromApi = false;
  bool isMealBaselineFromApi = false;

  // ✅ Yerel baseline'lar (kaydedilmiş son durum)
  bool? _baselineYoklamaGeldi;
  final Map<String, int?> _baselineMealDurum = {
    'kahvalti': null,
    'ogle': null,
    'ikindi': null,
  };

  final ValueNotifier<bool> isFormValid = ValueNotifier(false);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  late final VoidCallback _controllerListener;

  static const Map<String, int> _yemekReverseMapping = {
    'Hiç': 0,
    'Çeyrek': 1,
    'Yarım': 2,
    'Tam': 3,
  };

  @override
  void initState() {
    super.initState();
    controller = OgrenciTakipController();

    _controllerListener = () => setState(() {});
    controller.addListener(_controllerListener);
    controller.fetchOgrenciList();

    controller.takipList.addListener(_updateUIFromTakipData);
  }

  @override
  void dispose() {
    controller.removeListener(_controllerListener);
    controller.takipList.removeListener(_updateUIFromTakipData);
    controller.dispose();
    selectedDate.dispose();
    isFormValid.dispose();
    isLoading.dispose();
    super.dispose();
  }

  void onOgrenciChanged(String? value) {
    setState(() {
      selectedOgrenciId = value;
    });
    _fetchTakipData();
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    _fetchTakipData();
  }

  void _fetchTakipData() {
    // Öğrenci/tarih değişince UI state'lerini temizle
    setState(() {
      isYoklamaGeldi = null;

      moodData = null;
      currentMood = null;
      isMoodBaselineFromApi = false;

      sleepData = null;
      currentSleep = null;
      isSleepBaselineFromApi = false;

      mealSaved = false;
      moodSaved = false;
      sleepSaved = false;

      // Yemek verilerini temizle
      mealDataUI = {
        'Kahvaltı': null,
        'Öğle Yemeği': null,
        'İkindi Yemeği': null,
      };
      isMealBaselineFromApi = false;

      // ✅ Yerel baseline'ları da sıfırla
      _baselineYoklamaGeldi = null;
      _baselineMealDurum.updateAll((key, value) => null);

      isFormValid.value = false;
    });

    if (selectedOgrenciId != null) {
      final dateString =
          "${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}";
      controller.fetchTakipByOgrenciId(
        int.parse(selectedOgrenciId!),
        dateString,
      );
    }
  }

  void _updateUIFromTakipData() {
    final takipData = controller.takipList.value;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (takipData.isNotEmpty) {
        final firstData = takipData.first;
        setState(() {
          // Yoklama
          final yoklamaDurum = firstData.modelYoklamaDurum;
          isYoklamaGeldi = yoklamaDurum == null ? null : yoklamaDurum == 1;
          _baselineYoklamaGeldi = isYoklamaGeldi; // ✅ yerel baseline

          // Duygu (Database: 0=Kızgın,1=Üzgün,2=Mutsuz,3=Normal,4=Mutlu)
          final duyguDurum = firstData.modelDuyguDurum;
          if (duyguDurum != null) {
            const Map<int, String> duyguMapping = {
              4: 'Mutlu',
              3: 'Normal',
              2: 'Mutsuz',
              1: 'Üzgün',
              0: 'Kızgın',
            };
            moodData = duyguMapping[duyguDurum];
            currentMood = null;               // mavi yok, sadece yeşil görünsün
            isMoodBaselineFromApi = true;
          } else {
            moodData = null;
            currentMood = null;
            isMoodBaselineFromApi = false;
          }

          // Yemek - UI key'leriyle normalize et + ✅ yerel baseline doldur
          final yemekMap = firstData.modelYemekMap;
          mealDataUI = {
            'Kahvaltı': null,
            'Öğle Yemeği': null,
            'İkindi Yemeği': null,
          };

          const indexToBackendKey = {
            '0': 'kahvalti',
            '1': 'ogle',
            '2': 'ikindi',
            0: 'kahvalti',
            1: 'ogle',
            2: 'ikindi',
          };

          const backendToUIKeys = {
            'kahvalti': 'Kahvaltı',
            'ogle': 'Öğle Yemeği',
            'ikindi': 'İkindi Yemeği',
          };

          bool anyMeal = false;
          // baseline map'i temizle
          _baselineMealDurum.updateAll((key, value) => null);

          yemekMap.forEach((key, value) {
            final backendKey = indexToBackendKey[key] ?? key;
            final uiKey = backendToUIKeys[backendKey];
            final durum = value['durum']; // int 0..3
            if (uiKey != null) {
              if (durum != null) {
                const Map<int, String> yemekMapping = {
                  0: 'Hiç',
                  1: 'Çeyrek',
                  2: 'Yarım',
                  3: 'Tam',
                };
                final label = yemekMapping[durum];
                if (label != null) {
                  mealDataUI[uiKey] = label;
                  anyMeal = true;
                }
                _baselineMealDurum[backendKey] = durum; // ✅ baseline
              } else {
                _baselineMealDurum[backendKey] = null;
              }
            }
          });
          isMealBaselineFromApi = anyMeal;

          // Uyku (Database: 0=Uyumadı,1=Dinlendi,2=Uyudu)
          final uykuListesi = firstData.modelUykuListesi;
          if (uykuListesi.isNotEmpty) {
            final uykuDurum = uykuListesi.first['durum'];
            if (uykuDurum != null) {
              const Map<int, String> uykuMapping = {
                0: 'Uyumadı',
                1: 'Dinlendi',
                2: 'Uyudu',
              };
              sleepData = uykuMapping[uykuDurum];
              currentSleep = null;            // mavi yok, sadece yeşil görünsün
              isSleepBaselineFromApi = true;
            } else {
              sleepData = null;
              currentSleep = null;
              isSleepBaselineFromApi = false;
            }
          } else {
            sleepData = null;
            currentSleep = null;
            isSleepBaselineFromApi = false;
          }
        });
        _validateForm();
      } else {
        setState(() {
          isYoklamaGeldi = null;
          _baselineYoklamaGeldi = null;

          moodData = null;
          currentMood = null;
          isMoodBaselineFromApi = false;

          sleepData = null;
          currentSleep = null;
          isSleepBaselineFromApi = false;

          mealDataUI = {
            'Kahvaltı': null,
            'Öğle Yemeği': null,
            'İkindi Yemeği': null,
          };
          isMealBaselineFromApi = false;

          _baselineMealDurum.updateAll((key, value) => null);
        });
        _validateForm();
      }
    });
  }

  void _handleYoklamaSecimi(String secim) {
    setState(() {
      isYoklamaGeldi = secim == "Geldi";
    });
    _validateForm();
  }

  void _handleMealDataChanged(Map<String, String?> backendData) {
    // YemekContainer'dan backend key'leriyle veri geliyor
    // UI key'lerine çevir
    const backendToUIKeys = {
      'kahvalti': 'Kahvaltı',
      'ogle': 'Öğle Yemeği',
      'ikindi': 'İkindi Yemeği',
    };

    setState(() {
      backendData.forEach((backendKey, value) {
        final uiKey = backendToUIKeys[backendKey];
        if (uiKey != null) {
          mealDataUI[uiKey] = value;
        }
      });
      // Not: isMealBaselineFromApi'yi burada DEĞİŞTİRMİYORUZ
    });
    _validateForm();
  }

  void _handleMoodDataChanged(String? data) {
    setState(() {
      currentMood = data;       // mavi seçim
    });
    _validateForm();
  }

  void _handleSleepDataChanged(String? data) {
    setState(() {
      currentSleep = data;      // mavi seçim
    });
    _validateForm();
  }

  void _validateForm() {
    bool changed = false;

    // ✅ Yoklama: sadece kullanıcı seçim yaptıysa ve baseline'dan farklıysa değişmiş say
    if (isYoklamaGeldi != null && isYoklamaGeldi != _baselineYoklamaGeldi) {
      changed = true;
    }

    // ✅ Duygu: yeni seçim varsa ve baseline'dan farklıysa
    if (currentMood != null && currentMood != moodData) {
      changed = true;
    }

    // ✅ Uyku: yeni seçim varsa ve baseline'dan farklıysa
    if (currentSleep != null && currentSleep != sleepData) {
      changed = true;
    }

    // ✅ Yemek: kullanıcı bir öğün için seçim yaptıysa ve baseline ile farklıysa
    final backendMeal = mealDataBackend;
    for (final k in ['kahvalti', 'ogle', 'ikindi']) {
      final String? label = backendMeal[k];
      if (label != null) {
        final int newVal = _yemekReverseMapping[label] ?? 0;
        final int? baseVal = _baselineMealDurum[k];
        if (baseVal == null || newVal != baseVal) {
          changed = true;
        }
      }
    }

    isFormValid.value = changed;
  }

  Future<void> _saveData() async {
    if (selectedOgrenciId == null || isYoklamaGeldi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen öğrenci ve yoklama durumunu seçin.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    isLoading.value = true;
    try {
      final yoklamaDurum = isYoklamaGeldi == true ? 1 : 0;
      final takip = controller.takipList.value.isNotEmpty
          ? controller.takipList.value.first
          : null;
      final yoklamaId = takip?.modelYoklamaID;
      final duyguId = takip?.modelDuyguID;
      final uykuListesi = takip?.modelUykuListesi ?? [];
      final uykuId = uykuListesi.isNotEmpty ? uykuListesi.first['id'] as int? : null;

      // Yoklama
      final yoklamaModel = PostOgrenciYoklamaModel(
        id: yoklamaId,
        ogrenciId: int.parse(selectedOgrenciId!),
        tarih:
        "${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}",
        durum: yoklamaDurum,
      );

      // Duygu Durumu
      int? duyguDurumInt;
      final moodToSave = currentMood ?? moodData;
      if (moodToSave != null) {
        const Map<String, int> moodReverseMapping = {
          'Mutlu': 4,
          'Normal': 3,
          'Mutsuz': 2,
          'Üzgün': 1,
          'Kızgın': 0,
        };
        duyguDurumInt = moodReverseMapping[moodToSave] ?? 0;
      }
      final duyguModel = PostOgrenciDuyguDurumModel(
        id: duyguId,
        ogrenciId: int.parse(selectedOgrenciId!),
        tarih:
        "${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}",
        durum: duyguDurumInt ?? 0,
      );

      // Uyku
      int? uykuDurumInt;
      final sleepToSave = currentSleep ?? sleepData;
      if (sleepToSave != null) {
        const Map<String, int> uykuReverseMapping = {
          'Uyumadı': 0,
          'Dinlendi': 1,
          'Uyudu': 2,
        };
        uykuDurumInt = uykuReverseMapping[sleepToSave] ?? 0;
      }
      final uykuModel = PostOgrenciUykuModel(
        id: uykuId,
        ogrenciId: int.parse(selectedOgrenciId!),
        tarih:
        "${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}",
        durum: uykuDurumInt ?? 0,
      );

      // Beslenme (kahvalti/ogle/ikindi) - mealDataBackend kullan
      List<PostOgrenciBeslenmeModel> beslenmeModels = [];
      final yemekMap = takip?.modelYemekMap ?? {};
      const Map<String, int> ogunKodlari = {
        'kahvalti': 0,
        'ogle': 1,
        'ikindi': 2,
      };

      for (final entry in ogunKodlari.entries) {
        final ogunKey = entry.key;
        final ogunInt = entry.value;
        final uiValue = mealDataBackend[ogunKey]; // Backend getter kullan
        final dbValue = uiValue != null ? _yemekReverseMapping[uiValue] ?? 0 : 0;
        final id = yemekMap[ogunKey]?['id'] as int?;
        beslenmeModels.add(
          PostOgrenciBeslenmeModel(
            id: id,
            ogrenciId: int.parse(selectedOgrenciId!),
            tarih:
            "${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}",
            ogun: ogunInt,
            durum: dbValue,
          ),
        );
      }

      // Postlar
      final yoklamaResult = await controller.postOgrenciYoklamaBatch([yoklamaModel]);

      bool duyguResult = true;
      if (moodToSave != null) {
        duyguResult = await controller.postOgrenciDuyguBatch([duyguModel]);
      }

      bool uykuResult = true;
      if (sleepToSave != null) {
        uykuResult = await controller.postOgrenciUykuBatch([uykuModel]);
      }

      bool beslenmeResult = true;
      final hasMealSelection =
          mealDataBackend['kahvalti'] != null ||
              mealDataBackend['ogle'] != null ||
              mealDataBackend['ikindi'] != null;
      if (hasMealSelection) {
        beslenmeResult = await controller.postOgrenciBeslenmeBatch(beslenmeModels);
      }

      if (yoklamaResult && duyguResult && uykuResult && beslenmeResult) {
        // Kaydet başarılı → parent tarafında baseline'ları güncelle
        setState(() {
          // DUYGU
          moodData = currentMood ?? moodData;
          isMoodBaselineFromApi = moodData != null;

          // UYKU
          sleepData = currentSleep ?? sleepData;
          isSleepBaselineFromApi = sleepData != null;

          // YEMEK - herhangi bir seçim varsa baseline olarak işaretle
          if (hasMealSelection) {
            for (final k in ['kahvalti', 'ogle', 'ikindi']) {
              final label = mealDataBackend[k];
              if (label != null) {
                _baselineMealDurum[k] = _yemekReverseMapping[label];
              }
            }
            isMealBaselineFromApi = true;
          }

          // YOKLAMA baseline'ını güncelle
          _baselineYoklamaGeldi = isYoklamaGeldi;

          // geçici seçimler temizlenebilir
          currentMood = null;
          currentSleep = null;

          // Her container için ayrı ayrı kaydet sinyali gönder
          mealSaved = !mealSaved;
          moodSaved = !moodSaved;
          sleepSaved = !sleepSaved;

          // ✅ kaydettikten sonra buton pasif olsun
          isFormValid.value = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tüm veriler başarıyla kaydedildi.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bazı veriler kaydedilirken hata oluştu.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e'), backgroundColor: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth * 0.02;

    final bool isFetching = controller.isLoadingOgrenciList.value;
    final String? errorMsg = controller.errorOgrenciList.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6FD),
      appBar: const CustomAppBar(title: "Öğrenci Takip"),
      body: errorMsg != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              errorMsg,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16.0,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOgrenciDropdown(),
                const SizedBox(height: 16),
                _buildDatePicker(context),
                const SizedBox(height: 16),

                if (isFetching) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else if (selectedOgrenciId == null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.yellow[50],
                      border: Border.all(color: Colors.orange.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Lütfen devam etmek için bir öğrenci seçin.",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ] else ...[
                  YoklamaContainer(
                    onYoklamaSecildi: _handleYoklamaSecimi,
                    initialValue:
                    isYoklamaGeldi == null
                        ? null
                        : isYoklamaGeldi == true
                        ? 'Geldi'
                        : 'Gelmedi',
                  ),
                  const SizedBox(height: 14),
                  if (isYoklamaGeldi == true) ...[
                    // YEMEK
                    YemekContainer(
                      onMealDataChanged: _handleMealDataChanged,
                      initialValues: mealDataUI, // UI key'leriyle gönder
                      isFromApi: isMealBaselineFromApi,
                      savedTrigger: mealSaved, // Sadece yemek için kaydet sinyali
                    ),
                    const SizedBox(height: 10),

                    // DUYGU
                    DuyguDurumuContainer(
                      onMoodDataChanged: _handleMoodDataChanged,
                      initialValue: moodData,                 // baseline (yeşil)
                      isFromApi: isMoodBaselineFromApi,
                      savedTrigger: moodSaved, // Sadece duygu için kaydet sinyali
                    ),
                    const SizedBox(height: 10),

                    // UYKU
                    UykuContainer(
                      onSleepDataChanged: _handleSleepDataChanged,
                      initialValue: sleepData,                // baseline (yeşil)
                      isFromApi: isSleepBaselineFromApi,
                      savedTrigger: sleepSaved, // Sadece uyku için kaydet sinyali
                    ),

                    const SizedBox(height: 20),
                    _buildSaveButton(),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.yellow[50],
                        border: Border.all(color: Colors.orange.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Diğer seçenekler için öğrencinin \"Geldi\" olarak işaretlenmesi gerekir.",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSaveButton(),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOgrenciDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Öğrenci Seçin',
        border: OutlineInputBorder(),
      ),
      value: selectedOgrenciId,
      hint: const Text('Öğrenci Seçin'),
      items: controller.ogrenciList.map((ogrenci) {
        return DropdownMenuItem<String>(
          value: ogrenci.id.toString(),
          child: Text('${ogrenci.ad} ${ogrenci.soyad}'),
        );
      }).toList(),
      onChanged: (value) {
        onOgrenciChanged(value);
      },
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tarih',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        ValueListenableBuilder<DateTime>(
          valueListenable: selectedDate,
          builder: (context, selectedDateValue, _) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFFCF7FA),
              ),
              child: DatePickerWidget(
                initialDate: selectedDateValue,
                onDateSelected: onDateSelected,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder<bool>(
        valueListenable: isFormValid,
        builder: (context, isFormValidValue, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, isLoadingValue, _) {
              return ElevatedButton(
                onPressed: (isFormValidValue && !isLoadingValue) ? _saveData : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValidValue ? Colors.deepPurple : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoadingValue
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Kaydet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
