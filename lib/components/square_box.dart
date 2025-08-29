import 'package:flutter/material.dart';

class SquareBox extends StatelessWidget {
  final String imagePath;

  const SquareBox({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Image.asset(
        imagePath,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
      ),
    );
  }
}
