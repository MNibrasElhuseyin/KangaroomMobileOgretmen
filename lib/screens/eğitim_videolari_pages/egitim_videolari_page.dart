import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';
import 'package:kangaroom_mobile/widgets/custom_appbar.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EgitimVideolariPage extends StatelessWidget {
  EgitimVideolariPage({Key? key}) : super(key: key);

  final List<Map<String, String>> videolar = const [
    {
      'baslik': '1. Etkinlik Tanımlama ve Onay',
      'youtubeId': 'ZnqbNXv2Zxk',
      'youtubeUrl': 'https://www.youtube.com/watch?v=ZnqbNXv2Zxk',
    },
    {
      'baslik': '2. Kıyafet Talep',
      'youtubeId': 'mE77On8uT6g',
      'youtubeUrl': 'https://www.youtube.com/watch?v=mE77On8uT6g',
    },
    {
      'baslik': '3. Öğrenci Analiz',
      'youtubeId': 'vfBpJQs29KE',
      'youtubeUrl': 'https://www.youtube.com/watch?v=vfBpJQs29KE',
    },
    {
      'baslik': '4. Öğrenci Takip',
      'youtubeId': 'KvKLOGGGHM4',
      'youtubeUrl': 'https://www.youtube.com/watch?v=KvKLOGGGHM4',
    },
    {
      'baslik': '5. Sınıf Takip',
      'youtubeId': 'Eaq_xNjJqP4',
      'youtubeUrl': 'https://www.youtube.com/watch?v=Eaq_xNjJqP4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: " Eğitim Videoları",
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Yardım butonu tıklandı!")),
              );
            },
          ),
        ],
      ),

      // ⬇️ Arka plan görseli YOK: düz zemin
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: ListView.builder(
        itemCount: videolar.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return _VideoKarti(
            baslik: videolar[index]['baslik']!,
            youtubeId: videolar[index]['youtubeId']!,
            youtubeUrl: videolar[index]['youtubeUrl']!,
          );
        },
      ),
    );
  }
}

class _VideoKarti extends StatefulWidget {
  const _VideoKarti({
    required this.baslik,
    required this.youtubeId,
    required this.youtubeUrl,
  });

  final String baslik;
  final String youtubeId;
  final String youtubeUrl;

  @override
  State<_VideoKarti> createState() => _VideoKartiState();
}

class _VideoKartiState extends State<_VideoKarti> {
  bool _isLoading = true;

  String getThumbnailUrl() {
    return 'https://img.youtube.com/vi/${widget.youtubeId}/0.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.baslik,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: _isLoading ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppConstants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Image.network(
                    getThumbnailUrl(),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                    frameBuilder: (
                      context,
                      child,
                      frame,
                      wasSynchronouslyLoaded,
                    ) {
                      if (wasSynchronouslyLoaded || frame != null) {
                        if (_isLoading) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) setState(() => _isLoading = false);
                          });
                        }
                        return child;
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onPressed: () async {
                final Uri url = Uri.parse(widget.youtubeUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Video açılamadı.")),
                  );
                }
              },
              icon: const Icon(Icons.ondemand_video),
              label: const Text(
                "İzlemek için YouTube",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
