import 'package:flutter/material.dart';
import '../../widgets/custom_menu.dart';

class HeaderSection extends StatelessWidget {
  final int selectedMenuItem;
  final Function(int) onItemSelected;
  final double iconSize;
  final double fontSize;

  const HeaderSection({
    super.key,
    required this.selectedMenuItem,
    required this.onItemSelected,
    this.iconSize = 28.0,
    this.fontSize = 11.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          CustomMenu(
            onItemSelected: onItemSelected,
            iconSize: iconSize,
            fontSize: fontSize,
            selectedMenuItem: selectedMenuItem,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}