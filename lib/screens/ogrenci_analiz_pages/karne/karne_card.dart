import 'package:flutter/material.dart';

class KarneCard extends StatefulWidget {
  final String alan;
  final List<String> maddeler;
  final Map<String, int> selectedScores; // API'den gelen puanlar (sabit)

  const KarneCard({
    super.key,
    required this.alan,
    required this.maddeler,
    this.selectedScores = const {},
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

  Map<int, String?> initialOptions = {};

  final Color yesilRenk = Colors.green.shade700;
  final Color yesilAcikRenk = Colors.green.shade100;

  @override
  void initState() {
    super.initState();
    _initInitialOptions();
  }

  @override
  void didUpdateWidget(covariant KarneCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedScores != widget.selectedScores ||
        oldWidget.maddeler != widget.maddeler) {
      _initInitialOptions();
    }
  }

  void _initInitialOptions() {
    Map<int, String?> tempInitial = {};
    for (int i = 0; i < widget.maddeler.length; i++) {
      final madde = widget.maddeler[i];
      final puan = widget.selectedScores[madde];
      String? label;
      switch (puan) {
        case 1:
          label = 'Yetersiz';
          break;
        case 2:
          label = 'Normal';
          break;
        case 3:
          label = 'İyi';
          break;
        case 4:
          label = 'Çok İyi';
          break;
        default:
          label = null;
      }
      tempInitial[i] = label;
    }
    setState(() {
      initialOptions = tempInitial;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          // Başlık - Sabit
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

          // İçerik
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

                                final initialOption = initialOptions[index];

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
                                              final label = option['label'];

                                              final isSelected =
                                                  initialOption == label;

                                              Color borderColor;
                                              Color bgColor;
                                              Color iconColor;

                                              if (isSelected) {
                                                borderColor = yesilRenk;
                                                bgColor = yesilAcikRenk;
                                                iconColor = yesilRenk;
                                              } else {
                                                borderColor =
                                                    Colors.grey.shade300;
                                                bgColor = Colors.white;
                                                iconColor = Colors.black87;
                                              }

                                              return Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                      ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // Tıklama kapalı
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
                                                              isSelected
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
