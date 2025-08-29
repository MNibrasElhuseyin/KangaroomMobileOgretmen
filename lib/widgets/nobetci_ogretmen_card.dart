import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'app_constant.dart';

// Sadece geliştirme ortamı için: SSL sertifika doğrulamasını devre dışı bırakır
http.Client getHttpClientAllowBadCert() {
  final ioc =
      HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
  return IOClient(ioc);
}

class NobetciOgretmenCard extends StatefulWidget {
  final Map<String, String> data;
  final bool isWeb;
  final int index;

  const NobetciOgretmenCard({
    required this.data,
    required this.isWeb,
    required this.index,
    super.key,
  });

  @override
  _NobetciOgretmenCardState createState() => _NobetciOgretmenCardState();
}

class _NobetciOgretmenCardState extends State<NobetciOgretmenCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final k = widget.data;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8),
      transform:
          Matrix4.identity()..scale(_isHovered && widget.isWeb ? 1.03 : 1.0),
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
            label: k['dosyaAdi'] ?? 'Nobetci dosyası',
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
                    final url = k['url'];
                    debugPrint('PDF indirme URL: $url');
                    if (url == null || url.isEmpty) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Dosya bağlantısı bulunamadı."),
                            backgroundColor: Colors.red[400],
                          ),
                        );
                      }
                      return;
                    }
                    try {
                      final client = getHttpClientAllowBadCert();
                      final response = await client.get(Uri.parse(url));
                      if (response.statusCode == 200) {
                        final bytes = response.bodyBytes;
                        final tempDir = await getTemporaryDirectory();
                        final filePath =
                            '${tempDir.path}/nobetci_ogretmen_${widget.index + 1}.pdf';
                        final file = File(filePath);
                        await file.writeAsBytes(bytes, flush: true);
                        await OpenFile.open(file.path);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Dosya indirilemedi. Sunucu hatası: ${response.statusCode}",
                              ),
                              backgroundColor: Colors.red[400],
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Dosya açılamadı: $e"),
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
                      horizontal:
                          widget.isWeb
                              ? AppConstants.webButtonPaddingH
                              : AppConstants.mobileButtonPaddingH,
                      vertical:
                          widget.isWeb
                              ? AppConstants.webButtonPaddingV
                              : AppConstants.mobileButtonPaddingV,
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
                  fontSize:
                      widget.isWeb
                          ? AppConstants.webFontSize
                          : AppConstants.mobileFontSize,
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
