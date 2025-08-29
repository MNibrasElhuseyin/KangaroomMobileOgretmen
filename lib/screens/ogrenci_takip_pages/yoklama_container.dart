import 'package:flutter/material.dart';

class YoklamaContainer extends StatefulWidget {
  final void Function(String)? onYoklamaSecildi;
  final String? initialValue;

  const YoklamaContainer({super.key, this.onYoklamaSecildi, this.initialValue});

  @override
  State<YoklamaContainer> createState() => _YoklamaContainerState();
}

class _YoklamaContainerState extends State<YoklamaContainer> {
  String? attendanceSelection;

  @override
  void initState() {
    super.initState();
    attendanceSelection = widget.initialValue;
  }

  @override
  void didUpdateWidget(YoklamaContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          attendanceSelection = widget.initialValue;
        });
        if (widget.initialValue != null && widget.onYoklamaSecildi != null) {
          widget.onYoklamaSecildi!(widget.initialValue!);
        }
      });
    }
  }

  final attendanceOptions = [
    {'icon': Icons.check, 'label': 'Geldi', 'color': Colors.green},
    {'icon': Icons.close, 'label': 'Gelmedi', 'color': Colors.red},
  ];

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Yoklama Anlamları"),
            content: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.check, color: Colors.green, size: 18),
                  ),
                  const TextSpan(text: ' : Geldi\n'),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(Icons.close, color: Colors.red, size: 18),
                  ),
                  const TextSpan(text: ' : Gelmedi'),
                ],
              ),
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

    return Container(
      width: screenWidth,
      padding: const EdgeInsets.all(14.0),
      margin: const EdgeInsets.only(bottom: 14.0),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Yoklama',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.indigo,
                  size: 20,
                ),
                onPressed: _showInfoDialog,
                tooltip: "Yoklama anlamlarını göster",
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                attendanceOptions.map((option) {
                  final isSelected = attendanceSelection == option['label'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        attendanceSelection = option['label'] as String;
                      });

                      if (widget.onYoklamaSecildi != null) {
                        widget.onYoklamaSecildi!(option['label'] as String);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 85,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? (option['color'] as Color).withOpacity(0.1)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color:
                              isSelected
                                  ? option['color'] as Color
                                  : Colors.grey.shade300,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            option['icon'] as IconData,
                            color:
                                isSelected
                                    ? option['color'] as Color
                                    : Colors.grey,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            option['label'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  isSelected
                                      ? option['color'] as Color
                                      : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: const Color(0xFFE3F2FD),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
