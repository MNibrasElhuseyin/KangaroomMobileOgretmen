import 'package:flutter/material.dart';

class YilSecici extends StatelessWidget {
  final String? seciliYil;
  final ValueChanged<String?> onChanged;
  final bool isWeb;

  const YilSecici({
    required this.seciliYil,
    required this.onChanged,
    required this.isWeb,
    super.key,
  });

  List<String> _getYillarListesi() {
    final currentYear = DateTime.now().year;
    final List<String> yillar = ['Tümü'];

    // Şimdiki yılın 3 yıl gerisinden şimdiki yıla kadar
    for (int i = currentYear - 3; i <= currentYear; i++) {
      yillar.add(i.toString());
    }

    return yillar;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> yillarListesi = _getYillarListesi();
    final currentYear = DateTime.now().year.toString();

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
      value: seciliYil == '' ? currentYear : seciliYil,
      hint: Text('Yıl', style: TextStyle(fontSize: isWeb ? 12 : 10, color: Colors.black)),
      items: yillarListesi.map((yil) {
        return DropdownMenuItem<String>(
          value: yil,
          child: Text(yil, style: TextStyle(fontSize: isWeb ? 12 : 10, color: Colors.black)),
        );
      }).toList(),
      onChanged: (secim) {
        onChanged(secim == 'Tümü' ? '' : secim);
      },
      style: TextStyle(fontSize: isWeb ? 12 : 10, color: Colors.black),
    );
  }
}