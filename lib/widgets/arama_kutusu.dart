import 'package:flutter/material.dart';
import 'app_constant.dart';


class AramaKutusu extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isWeb;

  const AramaKutusu({
    required this.onChanged,
    required this.isWeb,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Dosya adında ara...',
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).primaryColor,
          size: isWeb ? 24 : 20,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isWeb ? 16 : 12,
          vertical: isWeb ? 12 : 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
      ),
      style: TextStyle(
        fontSize: isWeb ? AppConstants.webFontSize : AppConstants.mobileFontSize,
      ),
      onChanged: onChanged,
    );
  }
}