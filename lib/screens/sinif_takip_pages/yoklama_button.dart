// yoklama_button.dart
// Amaç: Yoklama almak için buton, seçili ID'leri toplamak için kullanılır.

import 'package:flutter/material.dart';

class YoklamaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const YoklamaButton({super.key, this.onPressed, this.label = 'Yoklama Al'});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
