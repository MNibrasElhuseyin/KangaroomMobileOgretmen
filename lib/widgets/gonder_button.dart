import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final VoidCallback? onPressed; // Nullable yapıldı

  const SendButton({this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Gönder'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}