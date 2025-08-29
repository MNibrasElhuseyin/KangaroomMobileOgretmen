// file: lib/pages/ogrenci_takip/yemek_container.dart
import 'package:flutter/material.dart';

class YemekContainer extends StatefulWidget {
  /// Parent'a sadece kullanıcı etkileşimiyle bildirim yapılır.
  final Function(Map<String, String?>) onMealDataChanged;

  /// Başlangıç (API) değerleri. Örn:
  /// { 'KahvaltÄ±': 'Tam', 'Öğle Yemeği': 'Yarım', 'İkindi Yemeği': 'Çeyrek' }
  /// veya { 'kahvalti': 'Tam', 'ogle': 'Yarım', 'ikindi': 'Çeyrek' }
  final Map<String, String?>? initialValues;

  /// initialValues'un API'den geldiğini belirtir; true ise yeşil baseline olarak işaretlenir.
  final bool isFromApi;

  /// Parent bu değeri her değiştirdiğinde "Kaydet" tetiklenmiş kabul edilir.
  /// (Tavsiye: kaydet sonrası toggle etmek — true/false değişsin — yeterli.)
  final bool savedTrigger;

  const YemekContainer({
    super.key,
    required this.onMealDataChanged,
    this.initialValues,
    this.isFromApi = false,
    this.savedTrigger = false,
  });

  @override
  State<YemekContainer> createState() => _YemekContainerState();
}

class _YemekContainerState extends State<YemekContainer> {
  /// Yeşil referans (API'den gelen ya da Kaydet'ten sonra güncellenen)
  final Map<String, String?> _apiBaseline = {
    'kahvalti': null,
    'ogle': null,
    'ikindi': null,
  };

  /// Kullanıcının geçici (mavi) seçimleri
  final Map<String, String?> _tempSelection = {
    'kahvalti': null,
    'ogle': null,
    'ikindi': null,
  };

  final Map<String, Map<String, String>> _mealOptions = const {
    'Hiç': {'icon': '⌀', 'desc': 'Hiç'},
    'Çeyrek': {'icon': '🥄', 'desc': 'Çeyrek'},
    'Yarım': {'icon': '🍽️', 'desc': 'Yarım'},
    'Tam': {'icon': '🍲', 'desc': 'Tam'},
  };

  // UI label'ları ile backend key'leri arasında dönüşüm
  final Map<String, String> _labelToBackend = {
    'Kahvaltı': 'kahvalti',
    'Öğle Yemeği': 'ogle',
    'İkindi Yemeği': 'ikindi',
  };

  final Map<String, String> _backendToLabel = {
    'kahvalti': 'Kahvaltı',
    'ogle': 'Öğle Yemeği',
    'ikindi': 'İkindi Yemeği',
  };

  @override
  void initState() {
    super.initState();
    _hydrateApiBaselineFromInitials();
  }

  @override
  void didUpdateWidget(covariant YemekContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // initialValues veya isFromApi değiştiyse baseline'ı yeniden kur
    final bool initialsChanged =
        widget.initialValues != oldWidget.initialValues ||
            widget.isFromApi != oldWidget.isFromApi;

    if (initialsChanged) {
      _hydrateApiBaselineFromInitials();
      // Yeni veri geldi; geçici seçimleri sıfırla
      _tempSelection.updateAll((key, value) => null);
      setState(() {});
    }

    // savedTrigger değiştiyse VE yemekte gerçekten değişiklik varsa: mavi olanlar yeni baseline olsun
    if (widget.savedTrigger != oldWidget.savedTrigger) {
      final bool hasMealSelection = _tempSelection.values.any((value) => value != null);
      if (hasMealSelection) {
        _handleSave();
      }
    }
  }

  void _hydrateApiBaselineFromInitials() {
    // Önce tüm baseline'ları temizle
    _apiBaseline.updateAll((key, value) => null);

    if (widget.isFromApi && (widget.initialValues?.isNotEmpty ?? false)) {
      widget.initialValues!.forEach((k, v) {
        // Hem UI label'ı hem backend key'i destekle
        String? backendKey;
        if (_labelToBackend.containsKey(k)) {
          backendKey = _labelToBackend[k];
        } else if (_apiBaseline.containsKey(k)) {
          backendKey = k;
        }

        if (backendKey != null && _apiBaseline.containsKey(backendKey)) {
          _apiBaseline[backendKey] = v;
        }
      });
    }
  }

  void _handleSave() {
    bool anyChange = false;

    // Mavi seçimleri yeşil baseline'a aktar
    for (final k in _tempSelection.keys) {
      if (_tempSelection[k] != null) {
        _apiBaseline[k] = _tempSelection[k];
        _tempSelection[k] = null; // Mavi seçimi temizle
        anyChange = true;
      }
    }

    if (anyChange) {
      setState(() {});
    }
  }

  void _onTap(String mealKey, String optionLabel) {
    final String? currentBaseline = _apiBaseline[mealKey];
    final String? currentTemp = _tempSelection[mealKey];

    // Eğer tıklanan seçenek zaten baseline ise
    if (currentBaseline != null && currentBaseline == optionLabel) {
      // Mavi seçim varsa onu temizle (yeşile geri dön)
      if (currentTemp != null) {
        setState(() => _tempSelection[mealKey] = null);
        widget.onMealDataChanged(_mergedForParent());
        return;
      }
      // Mavi seçim yoksa ve baseline'a tekrar tıklandıysa hiçbir şey yapma
      return;
    }

    // Eğer tıklanan seçenek zaten mavi seçimse, onu temizle
    if (currentTemp != null && currentTemp == optionLabel) {
      setState(() => _tempSelection[mealKey] = null);
      widget.onMealDataChanged(_mergedForParent());
      return;
    }

    // Farklı bir seçime tıklanırsa mavi olarak işaretle
    setState(() => _tempSelection[mealKey] = optionLabel);
    widget.onMealDataChanged(_mergedForParent());
  }

  /// Parent'a gönderilecek birleşik görünüm:
  /// mavi varsa mavi, yoksa yeşil; backend anahtarlarıyla döndür.
  Map<String, String?> _mergedForParent() {
    final Map<String, String?> out = {};
    for (final k in _apiBaseline.keys) {
      final String? tempValue = _tempSelection[k];
      final String? baseValue = _apiBaseline[k];
      out[k] = tempValue ?? baseValue;
    }
    return out;
  }

  ({Color bg, Color border, Color text}) _colorsFor(String mealKey, String optionLabel) {
    final String? baselineValue = _apiBaseline[mealKey];
    final String? tempValue = _tempSelection[mealKey];

    // Önce mavi seçimi kontrol et
    final bool isTemp = tempValue != null && tempValue == optionLabel;
    if (isTemp) {
      return (bg: Colors.blue.withOpacity(0.15), border: Colors.blue, text: Colors.blue);
    }

    // Sonra yeşil baseline'ı kontrol et
    final bool isBaseline = baselineValue != null && baselineValue == optionLabel;
    if (isBaseline) {
      return (bg: Colors.green.withOpacity(0.15), border: Colors.green, text: Colors.green);
    }

    // Seçilmemiş durum
    return (bg: Colors.white, border: Colors.grey.shade300, text: Colors.grey[600]!);
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Yemek Miktarları"),
        content: const Text(
          "⌀: Hiç\n"
              "🥄: Çeyrek Porsiyon\n"
              "🍽️: Yarım Porsiyon\n"
              "🍲: Tam Porsiyon",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Kapat")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Yemek', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.indigo, size: 18),
                onPressed: _showInfoDialog,
                tooltip: "Yemek miktarları hakkında bilgi",
              ),
            ],
          ),
          const SizedBox(height: 6),
          _buildMealRow('Kahvaltı', 'kahvalti', screenWidth),
          _buildMealRow('Öğle Yemeği', 'ogle', screenWidth),
          _buildMealRow('İkindi Yemeği', 'ikindi', screenWidth),
        ],
      ),
    );
  }

  Widget _buildMealRow(String title, String mealKey, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.3,
            child: Text(title, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _mealOptions.entries.map((entry) {
                final option = entry.key;
                final icon = entry.value['icon']!;
                final desc = entry.value['desc']!;
                final c = _colorsFor(mealKey, option);

                return SizedBox(
                  width: 50,
                  child: GestureDetector(
                    onTap: () => _onTap(mealKey, option),
                    child: Tooltip(
                      message: desc,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.0),
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: c.bg,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: c.border,
                            width: (c.border == Colors.grey.shade300) ? 1 : 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(icon, style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 4),
                            Text(
                              desc,
                              style: TextStyle(fontSize: 8, color: c.text),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}