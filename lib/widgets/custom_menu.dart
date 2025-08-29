import 'package:flutter/material.dart';
import 'app_constant.dart';

class CustomMenu extends StatelessWidget {
  final Function(int) onItemSelected;
  final double iconSize;
  final double fontSize;
  final int selectedMenuItem;

  const CustomMenu({
    required this.onItemSelected,
    this.iconSize = 28.0,
    this.fontSize = 11.0,
    required this.selectedMenuItem,
    super.key,
  });

  final List<Map<String, dynamic>> menuItems = const [
    {'title': 'Yoklama', 'icon': Icons.check_circle},
    {'title': 'Duygu Durum', 'icon': Icons.mood},
    {'title': 'Uyku', 'icon': Icons.bed},
    {'title': 'Beslenme', 'icon': Icons.restaurant},
    {'title': 'İlaç', 'icon': Icons.local_pharmacy},
    {'title': 'Kıyafet', 'icon': Icons.checkroom},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: iconSize + fontSize + 20 + 25 + 16,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: menuItems.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedMenuItem == index;

          // 1) Temel renk (listeyi döndürerek kullan)
          final Color baseColor =
              AppConstants.cardColors[index % AppConstants.cardColors.length];

          // 2) Seçili durum için biraz koyulaştır
          final Color selectedColor = _darken(baseColor, 0.12);

          // 3) Sınır çizgisi için bir tık daha koyu
          final Color borderColor = _darken(
            baseColor,
            isSelected ? 0.25 : 0.18,
          );

          // 4) Metin/ikon rengi arka plana göre otomatik
          final Color fgColor = isSelected ? Colors.white : Colors.black87;

          return GestureDetector(
            onTap: () => onItemSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : baseColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isSelected ? 0.12 : 0.08),
                    spreadRadius: 1,
                    blurRadius: isSelected ? 4 : 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    menuItems[index]['icon'],
                    size: iconSize,
                    color: fgColor,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    menuItems[index]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: fgColor, // <-- sabit siyah yerine fgColor
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Yardımcılar ---

  /// Verilen rengi HSL uzayında amount kadar koyulaştırır (0–1 arası).
  static Color _darken(Color c, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(c);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// Arka plan rengine göre okunaklı önplan rengi (siyah/beyaz) seçer.
  static Color _onColor(Color bg) {
    // perceptual kontrast için luminance eşiği
    final luminance = bg.computeLuminance(); // 0 (siyah) — 1 (beyaz)
    return luminance > 0.6 ? Colors.black : Colors.white;
  }
}
