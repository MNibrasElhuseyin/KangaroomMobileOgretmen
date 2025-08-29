import 'package:flutter/material.dart';
import 'app_constant.dart';

class AySecici extends StatelessWidget {
  final String? seciliAy;
  final ValueChanged<String?> onChanged;
  final bool isWeb;

  const AySecici({
    required this.seciliAy,
    required this.onChanged,
    required this.isWeb,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> aylarListesi = ['Tüm Aylar', ...AppConstants.aylar];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: isWeb ? 8 : 6,
            vertical: isWeb ? 4 : 2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        isDense: true,
      ),
      value: seciliAy == '' ? 'Tüm Aylar' : seciliAy,
      hint: Text('Ay', style: TextStyle(fontSize: isWeb ? 12 : 10, color: Colors.black)),
      items: aylarListesi.map((ay) {
        return DropdownMenuItem<String>(
          value: ay,
          child: Text(ay, style: TextStyle(fontSize: isWeb ? 12 : 10, color: Colors.black)),
        );
      }).toList(),
      onChanged: (secim) => onChanged(secim == 'Tüm Aylar' ? '' : secim),
      style: TextStyle(fontSize: isWeb ? 12 : 10, color: Colors.black),
    );
  }
}
