// table_error.dart
// Amaç: Tablo verisi veya yapılandırması hatalı olduğunda hata mesajı göstermek.
// Kullanım: Eksik veri veya sütun/başlık uyumsuzluğu gibi durumlarda kullanıcıya hata bildirir.

import 'package:flutter/material.dart';

class TableError extends StatelessWidget {
  final String message;

  const TableError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.red),
      ),
    );
  }
}