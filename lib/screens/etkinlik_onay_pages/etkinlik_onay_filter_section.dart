import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  final List<String> etkinlikler;
  final List<String> durumlar;
  final String? seciliEtkinlik;
  final String? seciliDurum;
  final Function(String?) onEtkinlikChanged;
  final Function(String?) onDurumChanged;

  const FilterSection({
    super.key,
    required this.etkinlikler,
    required this.durumlar,
    required this.seciliEtkinlik,
    required this.seciliDurum,
    required this.onEtkinlikChanged,
    required this.onDurumChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDropdown(
            "Etkinlik",
            "Etkinlik Seçin",  // Hint olarak burada yazıyor
            etkinlikler,
            seciliEtkinlik,
            onEtkinlikChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDropdown(
            "Durum",
            "", // Hint boş bırakıldı, "Tümü" kaldırıldı
            durumlar,
            seciliDurum,
            onDurumChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String hint,
    List<String> items,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.pink)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFCF7FA),
            border: Border.all(color: Colors.blue.shade100),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: hint.isEmpty ? null : Text(hint),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              items: items.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}