import 'package:flutter/material.dart';
//import 'package:kangaroom_mobile/constants/app_constant.dart';
import 'package:kangaroom_mobile/screens/beslenme_programi_pages/beslenme_programi_page.dart';
import 'package:kangaroom_mobile/screens/boy_kilo_pages/boy_kilo_page.dart';
import 'package:kangaroom_mobile/screens/ders_resimleri_pages/ders_resimleri_page.dart';
import 'package:kangaroom_mobile/screens/eğitim_videolari_pages/egitim_videolari_page.dart';
import 'package:kangaroom_mobile/screens/etkinlik_onay_pages/etkinlik_onay_page.dart';
import 'package:kangaroom_mobile/screens/etkinlik_tanimlama_pages/etkinlik_tanimlama_page.dart';
import 'package:kangaroom_mobile/screens/karne_pages/karne_page.dart';
import 'package:kangaroom_mobile/screens/kiyafet_talep_pages/kiyafet_talep_page.dart';
import 'package:kangaroom_mobile/screens/mesaj_pages/mesaj_page.dart';
import 'package:kangaroom_mobile/screens/nobetci_ogretmen_pages/nobetci_ogretmen_page.dart';
import 'package:kangaroom_mobile/screens/ogrenci_takip_pages/ogrenci_takip_page.dart';
import 'package:kangaroom_mobile/screens/profil_pages/profile_page.dart';
import 'package:kangaroom_mobile/screens/sinif_takip_pages/sinif_takip_page.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';
import 'package:kangaroom_mobile/widgets/card_custom.dart';
import 'package:kangaroom_mobile/config/global_config.dart';
import '../ogrenci_analiz_pages/analiz/ogrenci_analiz_page.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa>
    with SingleTickerProviderStateMixin {
  double _logoOpacity = 0;
  String anaSayfaAd = GlobalConfig.ad;
  String anaSayfaSoyad = GlobalConfig.soyad;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _logoOpacity = 1;
      });
    });
  }

  static final List<Map<String, dynamic>> sayfalar = [
    {
      'baslik': 'Sınıf Takip',
      'ikonAsset': 'assets/icons/sınıftakip.png',
      'sayfa': const SinifTakipPage(),
    },
    {
      'baslik': 'Öğrenci Takip',
      'ikonAsset': 'assets/icons/ogrenci.png',
      'sayfa': const OgrenciTakipPage(),
    },
    {
      'baslik': 'Sosyal Ağ',
      'ikon': Icons.photo,
      'sayfa': const DersResimleriPage(),
    },
    {'baslik': 'Mesaj', 'ikon': Icons.message, 'sayfa':  MesajPage()},
    {
      'baslik': 'Kıyafet Talep',
      'ikon': Icons.checkroom,
      'sayfa': const KiyafetTalepPage(),
    },
    {
      'baslik': 'Boy-Kilo',
      'ikonAsset': 'assets/icons/weight-height.png',
      'sayfa': const BoyKiloPage(),
    },
    {
      'baslik': 'Etkinlik Tanımlama',
      'ikon': Icons.event_note,
      'sayfa': const EtkinlikTanimlamaPage(),
    },
    {
      'baslik': 'Etkinlik Onay',
      'ikon': Icons.verified,
      'sayfa': const EtkinlikOnayPage(),
    },
    {
      'baslik': 'Öğrenci Analiz',
      'ikon': Icons.bar_chart,
      'sayfa': const OgrenciAnalizPage(),
    },
    {'baslik': 'Gelişim Raporu', 'ikon': Icons.school, 'sayfa': const KarnePage()},
    {
      'baslik': 'Beslenme Programı',
      'ikon': Icons.restaurant,
      'sayfa': const BeslenmeProgramiPage(),
    },
    {
      'baslik': 'Nöbetçi Öğretmen',
      'ikonAsset': 'assets/icons/teacher.png',
      'sayfa': const NobetciOgretmenPage(),
    },
    {
      'baslik': 'Eğitim Videoları',
      'ikon': Icons.video_library,
      'sayfa': EgitimVideolariPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final crossAxisCount = _calculateCrossAxisCount(screenWidth);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryColor,
        elevation: 4,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            AnimatedOpacity(
              opacity: _logoOpacity,
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              child: Image.asset(
                'assets/images/kangapp.png',
                height: 44,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "$anaSayfaAd $anaSayfaSoyad",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white, size: 26),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilPage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(isWeb ? 24.0 : 12.0),
        child: GridView.builder(
          itemCount: sayfalar.length,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppConstants.gridSpacing,
            mainAxisSpacing: AppConstants.gridSpacing,
            childAspectRatio: isWeb ? 1.0 : 1.1,
          ),
          itemBuilder: (context, index) {
            final item = sayfalar[index];
            final cardColor =
                AppConstants.cardColors[index % AppConstants.cardColors.length];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item['sayfa']),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(AppConstants.cardPadding),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CustomCard(
                  title: item['baslik'],
                  icon: item['ikon'],
                  iconAsset: item['ikonAsset'],
                  page: item['sayfa'],
                  isWeb: isWeb,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) return 6;
    if (screenWidth > 900) return 4;
    if (screenWidth > 600) return 3;
    return 2;
  }
}
