import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/screens/ogrenci_analiz_pages/boy_kilo_analiz/data_table_widget.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';
import 'package:kangaroom_mobile/widgets/custom_appbar.dart';
import 'package:kangaroom_mobile/screens/ogrenci_analiz_pages/boy_kilo_analiz/boy_kilo_chart_widget.dart';
import 'package:kangaroom_mobile/screens/ogrenci_analiz_pages/boy_kilo_analiz/kilo_chart_widget.dart';
import 'package:kangaroom_mobile/screens/ogrenci_analiz_pages/boy_kilo_analiz/boy_kilo_controller.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_boy_kilo.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_analiz.dart';

class BoyKiloAnalizPage extends StatefulWidget {
  final int ogrenciID;
  final GetOgrenciAnaliz ogrenci;

  const BoyKiloAnalizPage({
    super.key,
    required this.ogrenciID,
    required this.ogrenci,
  });

  @override
  _BoyKiloAnalizPageState createState() => _BoyKiloAnalizPageState();
}

class _BoyKiloAnalizPageState extends State<BoyKiloAnalizPage> {
  final BoyKiloController _controller = BoyKiloController();

  bool _isLoading = true;
  String? _error;
  List<GetOgrenciBoyKilo> _boyKiloList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _controller.fetchBoyKiloData(widget.ogrenciID);
      setState(() {
        _boyKiloList = _controller.boyKiloList;
        _isLoading = false;
      });
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      String cleanMessage;
      if (message.contains('Exception: ')) {
        cleanMessage = message.replaceFirst('Exception: ', '');
      } else {
        cleanMessage = message;
      }
      setState(() {
        _error = cleanMessage;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        appBar: const CustomAppBar(title: "Boy Kilo"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        appBar: const CustomAppBar(title: "Boy Kilo"),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.redAccent),
              const SizedBox(height: 12),
              const Text(
                'Bağlantı sorunu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    if (_boyKiloList.isEmpty) {
      return Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        appBar: const CustomAppBar(title: "Boy Kilo"),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.redAccent),
              const SizedBox(height: 12),
              const Text(
                'Bağlantı sorunu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text(
                '📶 İnternet bağlantınızı kontrol ediniz',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    final tarihler =
        _boyKiloList
            .map(
              (e) =>
                  "${e.modelTarih.day.toString().padLeft(2, '0')}.${e.modelTarih.month.toString().padLeft(2, '0')}.${e.modelTarih.year}",
            )
            .toList();
    final boylar = _boyKiloList.map((e) => e.modelBoy).toList();
    final kilolar = _boyKiloList.map((e) => e.modelKilo).toList();

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: const CustomAppBar(title: "Boy Kilo"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ogrenciBilgisiCard(widget.ogrenci),
            const SizedBox(height: 24),
            _sectionTitle("Boy - Kilo Tablosu"),
            const SizedBox(height: 12),
            BoyKiloTable(tarihler: tarihler, boylar: boylar, kilolar: kilolar),
            const SizedBox(height: 24),
            _sectionTitle("Boy Grafiği"),
            const SizedBox(height: 12),
            _buildGraph(BoyChart(boylar: boylar, tarihler: tarihler)),
            const SizedBox(height: 24),
            _sectionTitle("Kilo Grafiği"),
            const SizedBox(height: 12),
            _buildGraph(KiloChart(kilolar: kilolar, tarihler: tarihler)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppConstants.primaryColor,
      ),
    );
  }

  Widget _buildGraph(Widget child) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(1, 2)),
        ],
      ),
      child: SizedBox(height: 220, child: child),
    );
  }

  Widget _ogrenciBilgisiCard(GetOgrenciAnaliz ogrenci) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_outline,
            color: Colors.indigo,
            size: 28,
          ), // person_outline olarak güncelledim
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ogrenci
                      .adSoyad, // modelAdSoyad yerine doğrudan adSoyad kullandım
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${ogrenci.sinif} Sınıfı", // modelSinif yerine doğrudan sinif kullandım
                  style: TextStyle(fontSize: 14, color: Colors.black87,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
