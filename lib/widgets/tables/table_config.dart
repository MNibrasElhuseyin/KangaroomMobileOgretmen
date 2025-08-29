// table_config.dart
// Amaç: Tablo için stil ve sabit ayarları tanımlamak.
// Kullanım: Padding, yazı stilleri ve sütun genişlikleri gibi sabit değerleri merkezi bir yerde tutar.
// Ek: Checkbox sütunu için taşmayı önlemek adına genişlik artırıldı.

import 'package:flutter/material.dart';

class TableConfig {
  static const EdgeInsets cellPadding = EdgeInsets.all(8.0);
  static const TextStyle headerTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  static const TextStyle cellTextStyle = TextStyle(fontSize: 13);
  static const double minColumnWidth = 100.0;
  static const double maxColumnWidth = 200.0;
  static const double checkboxColumnWidth =
      150.0; // "Tümünü Seç" için artırıldı
  static const double maxCQheckboxColumnWidth = 180.0; // Maksimum sınır
  static const Color borderColor = Colors.grey;
  static const Color headerBackgroundColor = Colors.grey;
}
