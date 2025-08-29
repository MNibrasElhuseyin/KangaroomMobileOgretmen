import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_constant.dart';

class BeslenmeCard extends StatefulWidget {
  final Map<String, String> data;
  final bool isWeb;
  final int index;

  const BeslenmeCard({
    required this.data,
    required this.isWeb,
    required this.index,
    super.key,
  });

  @override
  _BeslenmeCardState createState() => _BeslenmeCardState();
}

class _BeslenmeCardState extends State<BeslenmeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final k = widget.data;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8),
      transform: Matrix4.identity()..scale(_isHovered && widget.isWeb ? 1.03 : 1.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: widget.isWeb ? 6 : 4,
          shadowColor: Colors.grey.withOpacity(0.3),
          child: Semantics(
            label: k['dosyaAdi'] ?? 'Beslenme dosyası',
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.isWeb ? 20 : 16,
                vertical: widget.isWeb ? 12 : 8,
              ),
              leading: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA726), Color(0xFFFF5722)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final url = Uri.parse(k['url']!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Dosya açılamadı."),
                            backgroundColor: Colors.red[400],
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.isWeb ? AppConstants.webButtonPaddingH : AppConstants.mobileButtonPaddingH,
                      vertical: widget.isWeb ? AppConstants.webButtonPaddingV : AppConstants.mobileButtonPaddingV,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    "İndir",
                    style: TextStyle(
                      fontSize: widget.isWeb ? 14 : 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              title: Text(
                k['dosyaAdi']!,
                style: TextStyle(
                  fontSize: widget.isWeb ? AppConstants.webFontSize : AppConstants.mobileFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tarih: ${k['tarih']}",
                    style: TextStyle(
                      fontSize: widget.isWeb ? 14 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "Ay: ${k['ay']}",
                    style: TextStyle(
                      fontSize: widget.isWeb ? 14 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "Hafta: ${k['hafta']}",
                    style: TextStyle(
                      fontSize: widget.isWeb ? 14 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: Text(
                "#${widget.index + 1}",
                style: TextStyle(
                  fontSize: widget.isWeb ? 14 : 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}