import 'package:flutter/material.dart';

class DuyguDurumuContainer extends StatefulWidget {
  final Function(String?) onMoodDataChanged;
  final String? initialValue;
  final bool isFromApi;
  final bool savedTrigger;

  const DuyguDurumuContainer({
    super.key,
    required this.onMoodDataChanged,
    this.initialValue,
    this.isFromApi = false,
    this.savedTrigger = false,
  });

  @override
  State<DuyguDurumuContainer> createState() => _DuyguDurumuContainerState();
}

class _DuyguDurumuContainerState extends State<DuyguDurumuContainer> {
  String? _apiBaseline;
  String? _tempSelection;

  final List<Map<String, String>> moods = const [
    {'emoji': '😊', 'label': 'Mutlu'},
    {'emoji': '🙂', 'label': 'Normal'},
    {'emoji': '😐', 'label': 'Mutsuz'},
    {'emoji': '😔', 'label': 'Üzgün'},
    {'emoji': '😢', 'label': 'Kızgın'},
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
  void didUpdateWidget(covariant DuyguDurumuContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool needsUpdate = false;

    if (widget.initialValue != oldWidget.initialValue ||
        widget.isFromApi != oldWidget.isFromApi) {
      _apiBaseline = (widget.isFromApi && (widget.initialValue?.isNotEmpty ?? false))
          ? widget.initialValue
          : null;
      _tempSelection = null;
      needsUpdate = true;
    }

    if (needsUpdate) setState(() {});
  }

  void _onTapLabel(String label) {
    if (_apiBaseline != null && label == _apiBaseline) {
      if (_tempSelection != null) {
        setState(() => _tempSelection = null);
      }
      widget.onMoodDataChanged(_apiBaseline);
      return;
    }

    setState(() => _tempSelection = label);
    widget.onMoodDataChanged(label);
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
                  'Duygu Durum',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.info_outline, color: Colors.indigo, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: moods.map((mood) {
              final String label = mood['label']!;
              final String emoji = mood['emoji']!;
              final c = _colorsFor(label);

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTapLabel(label),
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
                        Text(emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(label, style: TextStyle(fontSize: 8, color: c.text)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (display != null) ...[
            const SizedBox(height: 8),
            Text(
              "Seçilen Duygu: $display ${moods.firstWhere((m) => m['label'] == display)['emoji']}",
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
      color: const Color(0xFFFFF3E0),
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
