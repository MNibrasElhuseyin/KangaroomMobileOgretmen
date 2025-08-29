import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  /// Sayfadan aksiyon vermek için
  final List<Widget>? actions;

  /// İstersen özel leading (geri butonu vs.)
  final Widget? leading;

  /// Sağda sabit profil ikonu gözüksün mü?
  final bool showProfileAction;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showProfileAction = true,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // 56
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  double _logoOpacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _logoOpacity = 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstants.primaryColor,
      elevation: 4,
      titleSpacing: 0,

      // 🔁 Güncellenen kısım:
      leading:
          widget.leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),

      title: Row(
        children: [
          const SizedBox(width: 8),
          AnimatedOpacity(
            opacity: _logoOpacity,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            child: Image.asset(
              'assets/images/kangapp.png',
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        // sayfadan gelen aksiyonlar
        ...(widget.actions ?? const []),
      ],
    );
  }
}
