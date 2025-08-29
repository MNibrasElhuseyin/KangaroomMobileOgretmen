import 'package:flutter/material.dart';

class AppTextStyle {
  /// Küçük açıklama metni
  static const TextStyle MINI_DESCRIPTION_TEXT = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  /// Küçük ama kalın yazılmış açıklama
  static const TextStyle MINI_BOLD_DESCRIPTION_TEXT = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  /// Gri açıklama metni (örneğin: “not a member?” gibi)
  static const TextStyle MINI_DEFAULT_DESCRIPTION_TEXT = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  /// Başlık stili örneği
  static const TextStyle HEADING_TEXT = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF2D2D64),
  );

  /// Buton yazı stili
  static const TextStyle BUTTON_TEXT = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
