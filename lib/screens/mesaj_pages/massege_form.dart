import 'package:flutter/material.dart';
import '../../models/mesaj/get_ogrenci_list_all.dart';
import '../../widgets/gonder_button.dart';
import '../../widgets/icerik_acıklama_widget.dart';

class MessageForm extends StatefulWidget {
  final List<GetOgrenciListAllModel> ogrenciler;
  final void Function(String icerik, int? ogrenciId) onSend;
  final int? selectedOgrenciId;
  final void Function(int? ogrenciId) onOgrenciChanged;

  const MessageForm({
    super.key,
    required this.ogrenciler,
    required this.onSend,
    required this.selectedOgrenciId,
    required this.onOgrenciChanged,
  });

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  int? seciliOgrenciId;
  final TextEditingController _icerikController = TextEditingController();
  bool _canSend = false;

  @override
  @override
  void initState() {
    super.initState();
    seciliOgrenciId = widget.selectedOgrenciId ?? -1;
    _icerikController.addListener(() {
      setState(() {
        _canSend = _icerikController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void didUpdateWidget(covariant MessageForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedOgrenciId != oldWidget.selectedOgrenciId) {
      setState(() {
        seciliOgrenciId = widget.selectedOgrenciId;
      });
    }
  }

  @override
  void dispose() {
    _icerikController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (!_canSend) return;

    final icerik = _icerikController.text.trim();
    widget.onSend(icerik, seciliOgrenciId);

    // Gönderince inputu temizle ve butonu pasif yap
    _icerikController.clear();
    setState(() {
      _canSend = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Öğrenci",
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFCF7FA),
            border: Border.all(color: Colors.deepPurple.shade100),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: seciliOgrenciId,
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              dropdownColor: const Color(0xFFFCF7FA),
              isExpanded: true,
              style: const TextStyle(color: Colors.deepPurple, fontSize: 14),
              items:
                  widget.ogrenciler.map((ogrenci) {
                    return DropdownMenuItem<int>(
                      value: ogrenci.modelID,
                      child: Text(
                        ogrenci.modelAdSoyad,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  seciliOgrenciId = newValue;
                });
                widget.onOgrenciChanged(newValue);
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(minHeight: 70, maxHeight: 120),
            child: CustomInputWidget(controller: _icerikController),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SendButton(
                onPressed:
                    _canSend
                        ? _handleSend
                        : null, // null olursa buton disable olur
              ),
            ],
          ),
        ),
      ],
    );
  }
}
