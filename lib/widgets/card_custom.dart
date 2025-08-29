import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';
//import '../constants/app_constant.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? iconAsset;
  final Widget page;
  final bool isWeb;

  const CustomCard({
    super.key,
    required this.title,
    this.icon,
    this.iconAsset,
    required this.page,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize =
        isWeb ? AppConstants.iconSizeWeb : AppConstants.iconSizeMobile;
    final textSize =
        isWeb ? AppConstants.textSizeWeb : AppConstants.textSizeMobile;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconAsset != null)
          Image.asset(
            iconAsset!,
            color: AppConstants.accentColor,
            width: title == "Öğrenci Takip" ? iconSize + 10 : iconSize,
            height: title == "Öğrenci Takip" ? iconSize + 10 : iconSize,
            fit: BoxFit.contain,
          )
        else if (icon != null)
          Icon(icon, size: iconSize, color: AppConstants.accentColor)
        else
          const Icon(Icons.help_outline, size: 40, color: Colors.grey),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: textSize,
            color: AppConstants.textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
