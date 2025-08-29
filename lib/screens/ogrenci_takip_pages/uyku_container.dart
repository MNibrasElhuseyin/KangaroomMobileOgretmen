import 'package:flutter/material.dart';

class UykuContainer extends StatefulWidget {
  /// Kullanıcı uyku seçimi yaptığında tetiklenir.
  final Function(String?) onSleepDataChanged;

  /// Başlangıç (ör. API’den gelen) değer. Örn: "Uyudu" | "Dinlendi" | "Uyumadı"
  final String? initialValue;

  /// initialValue API’den/baselinelardan mı geldi? true ise YEŞİL olarak işaretlenir.
  final bool isFromApi;

  /// Parent kaydettiğinde (toggle edilerek) geçebileceğin tetikleyici.
  /// NOT: Container baseline terfisinin kararını vermez; sadece parent’tan gelen initialValue+isFromApi’ya uyar.
  final bool savedTrigger;

  const UykuContainer({
    super.key,
    required this.onSleepDataChanged,
    this.initialValue,
    this.isFromApi = false,
    this.savedTrigger = false,
  });

  @override
  State<UykuContainer> createState() => _UykuContainerState();
}

class _UykuContainerState extends State<UykuContainer> {
  /// YEŞİL baseline (API’den/kaydetten sonra parent tarafından gönderilir)
  String? _apiBaseline;

  /// MAVI geçici seçim (kullanıcı tıklayınca dolar; kaydet’e kadar mavi kalır)
  String? _tempSelection;

  final List<Map<String, String>> _sleepOptions = const [
    {'icon': '😴', 'label': 'Uyudu'},
    {'icon': '🧘', 'label': 'Dinlendi'},
    {'icon': '💤', 'label': 'Uyumadı'},
  ];

  @override
  void initState() {
    super.initState();
    _apiBaseline = (widget.isFromApi && (widget.initialValue?.isNotEmpty ?? false))
        ? widget.initialValue
        : null;
    _tempSelection = null;
  }

  @override
  void didUpdateWidget(covariant UykuContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool needsUpdate = false;

    // Parent baseline/flag değiştirdiyse container kendini buna göre yeniler.
    if (widget.initialValue != oldWidget.initialValue ||
        widget.isFromApi != oldWidget.isFromApi) {
      _apiBaseline = (widget.isFromApi && (widget.initialValue?.isNotEmpty ?? false))
          ? widget.initialValue
          : null;
      _tempSelection = null; // yeni veri geldi; geçici seçim sıfırlansın
      needsUpdate = true;
    }

    // ÖNEMLİ: savedTrigger değişince baseline TERFİSİNİ container yapmaz.
    // Parent, Kaydet’ten sonra initialValue + isFromApi:true vererek baseline’ı belirler.

    if (needsUpdate) setState(() {});
  }

  void _onTapLabel(String label) {
    // Baseline’a tıklanırsa sadece mavi temizlenir; yeşil kalsın
    if (_apiBaseline != null && label == _apiBaseline) {
      if (_tempSelection != null) {
        setState(() => _tempSelection = null);
      }
      widget.onSleepDataChanged(_apiBaseline);
      return;
    }

    // Farklı seçim → mavi
    setState(() => _tempSelection = label);
    widget.onSleepDataChanged(label);
  }

  ({Color bg, Color border, Color text}) _colorsFor(String label) {
    final bool isApi = _apiBaseline != null && label == _apiBaseline;
    final bool isTemp = _tempSelection != null &&
        label == _tempSelection &&
        _tempSelection != _apiBaseline;

    if (isApi) {
      return (
      bg: Colors.green.withOpacity(0.15),
      border: Colors.green,
      text: Colors.green,
      );
    }
    if (isTemp) {
      return (
      bg: Colors.blue.withOpacity(0.15),
      border: Colors.blue,
      text: Colors.blue,
      );
    }
    return (
    bg: Colors.white,
    border: Colors.grey.shade300,
    text: Colors.grey[600]!,
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Uyku Durumları"),
        content: const Text(
          "😴: Uyudu\n"
              "🧘: Dinlendi\n"
              "💤: Uyumadı\n",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final String? display = _tempSelection ?? _apiBaseline;

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
                child: Text(
                  'Uyku',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.indigo, size: 18),
                onPressed: _showInfoDialog,
                tooltip: "Uyku durumları hakkında bilgi",
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _sleepOptions.map((opt) {
              final label = opt['label']!;
              final icon = opt['icon']!;
              final c = _colorsFor(label);

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTapLabel(label),
                  child: Tooltip(
                    message: label,
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
                          Text(label, style: TextStyle(fontSize: 8, color: c.text)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (display != null) ...[
            const SizedBox(height: 8),
            Text(
              "Seçilen Uyku: $display",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFFFEBEE),
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
