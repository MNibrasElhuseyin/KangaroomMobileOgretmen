// table_data_processor.dart
// Amaç: Tablo verilerini işlemek ve düzenlemek.
// Kullanım: Satır verilerini sütun sayısına uydurur ve checkbox durumlarını ayarlar.
// CustomTable'daki _updateTableData mantığını ayırarak kodu temiz tutar.

import 'package:flutter/cupertino.dart';

class TableDataProcessor {
  static List<List<String>> adjustRowData(List<List<String>> rowData, int columnCount) {
    return rowData.map((row) {
      if (row.length < columnCount) {
        return [...row, ...List.filled(columnCount - row.length, '')];
      }
      if (row.length > columnCount) {
        debugPrint('Uyarı: Satır verisi sütun başlıkları uzunluğuna göre kesildi');
        return row.sublist(0, columnCount);
      }
      return row;
    }).toList();
  }

  static List<bool> adjustCheckboxStates(List<bool> checkboxStates, int rowCount) {
    return checkboxStates.length >= rowCount
        ? checkboxStates.sublist(0, rowCount)
        : [...checkboxStates, ...List.filled(rowCount - checkboxStates.length, false)];
  }
}