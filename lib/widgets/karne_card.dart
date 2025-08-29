import 'package:flutter/material.dart';

class KarneCard extends StatefulWidget {
  final String alan;
  final List<String> maddeler;
  final Map<String, String>
  selectedScores; // label olarak geliyor, kombine edilmiş: API ve kullanıcı seçimi

  final Map<String, String> apiScores; // API'den gelen orijinal seçimler

  final void Function(String madde, String? label)? onChanged;

  const KarneCard({
    super.key,
    required this.alan,
    required this.maddeler,
    required this.selectedScores,
    required this.apiScores,
    this.onChanged,
  });

  @override
  State<KarneCard> createState() => _KarneCardState();
}

class _KarneCardState extends State<KarneCard> with TickerProviderStateMixin {
  bool _isExpanded = false;

  final List<Map<String, String>> buttonOptions = [
    {'icon': '😞', 'label': 'Yetersiz'},
    {'icon': '😐', 'label': 'Normal'},
    {'icon': '😄', 'label': 'İyi'},
    {'icon': '❤️', 'label': 'Çok İyi'},
  ];

  void _onOptionTap(int index, String label) {
    final madde = widget.maddeler[index];
    final currentSelected = widget.selectedScores[madde];
    if (currentSelected == label) {
      // Aynı seçim, hiçbir değişiklik yok
      return;
    } else {
      widget.onChanged?.call(madde, label);
    }
  }

  @override
  Widget build(BuildContext context) {
    final yesilRenk = Colors.green.shade700;
    final yesilAcikRenk = Colors.green.shade100;

    final maviRenk = Colors.blue.shade700;
    final maviAcikRenk = Colors.blue.shade100;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.indigo.shade700, width: 1.5),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.indigo.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.alan,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child:
                _isExpanded
                    ? Container(
                      constraints: BoxConstraints(maxHeight: 475),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children:
                              widget.maddeler.asMap().entries.map((entry) {
                                int index = entry.key;
                                String madde = entry.value;

                                final selectedOption =
                                    widget.selectedScores[madde];
                                final apiOption = widget.apiScores[madde];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        madde,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          height: 1.4,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children:
                                            buttonOptions.map((option) {
                                              final label = option['label']!;

                                              Color borderColor;
                                              Color bgColor;
                                              Color iconColor;

                                              if (selectedOption == null) {
                                                // Hiç seçim yoksa gri
                                                borderColor =
                                                    Colors.grey.shade300;
                                                bgColor = Colors.white;
                                                iconColor = Colors.black87;
                                              } else if (selectedOption ==
                                                  apiOption) {
                                                // API ile aynı seçim: Yeşil
                                                if (label == selectedOption) {
                                                  borderColor = yesilRenk;
                                                  bgColor = yesilAcikRenk;
                                                  iconColor = yesilRenk;
                                                } else {
                                                  borderColor =
                                                      Colors.grey.shade300;
                                                  bgColor = Colors.white;
                                                  iconColor = Colors.black87;
                                                }
                                              } else {
                                                // Kullanıcı farklı seçim yaptı: sadece o buton mavi
                                                if (label == selectedOption) {
                                                  borderColor = maviRenk;
                                                  bgColor = maviAcikRenk;
                                                  iconColor = maviRenk;
                                                } else if (label == apiOption) {
                                                  // API seçimi butonu yeşil göster (kullanıcı farklı seçti ama api seçimi farklı butonda)
                                                  borderColor = yesilRenk;
                                                  bgColor = yesilAcikRenk;
                                                  iconColor = yesilRenk;
                                                } else {
                                                  borderColor =
                                                      Colors.grey.shade300;
                                                  bgColor = Colors.white;
                                                  iconColor = Colors.black87;
                                                }
                                              }

                                              return Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                      ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _onOptionTap(
                                                        index,
                                                        label,
                                                      );
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                        milliseconds: 200,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: bgColor,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: borderColor,
                                                          width:
                                                              (selectedOption ==
                                                                      label)
                                                                  ? 2.5
                                                                  : 1,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          option['icon'] ?? '',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: iconColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children:
                                              buttonOptions.map((option) {
                                                return Expanded(
                                                  child: Text(
                                                    option['label'] ?? '',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey[700],
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
