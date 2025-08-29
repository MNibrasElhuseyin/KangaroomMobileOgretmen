import 'package:flutter/material.dart';

class OgrenciDetayTextBox extends StatelessWidget {
  final String label;
  final String value;

  const OgrenciDetayTextBox(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        enabled: value.isNotEmpty, // boşsa disabled yapar
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}