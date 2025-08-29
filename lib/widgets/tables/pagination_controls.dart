import 'package:flutter/material.dart';

import '../../screens/sinif_takip_pages/PaginationControls.dart'; // Kendi dosya yolunuzu buraya yazın

class MyTablePage extends StatefulWidget {
  const MyTablePage({super.key});

  @override
  State<MyTablePage> createState() => _MyTablePageState();
}

class _MyTablePageState extends State<MyTablePage> {
  // --- Sayfalama için gerekli değişkenler ---
  int _currentPage = 0; // Mevcut sayfa (0'dan başlar)
  int _pageSize = 10;   // Her sayfada gösterilecek öğe sayısı
  int _totalItems = 100; // Toplam veri öğesi sayısı (API'den veya DB'den gelebilir)
  List<String> _currentItems = []; // Mevcut sayfada gösterilecek öğeler

  // Hesaplanan toplam sayfa sayısı
  int get _totalPages {
    if (_totalItems == 0) return 1; // Hiç öğe yoksa 1 sayfa göster
    return (_totalItems / _pageSize).ceil(); // Yuvarlama yaparak toplam sayfa sayısını bul
  }

  @override
  void initState() {
    super.initState();
    _fetchDataForPage(_currentPage); // Sayfa yüklendiğinde ilk sayfanın verilerini getir
  }

  // Yeni sayfaya göre verileri çeken/filtreleyen fonksiyon
  void _fetchDataForPage(int page) {
    // BURADA: Gerçek verilerinizi sayfalamanız gerekiyor.
    // Bu sadece bir örnek: Toplam öğelerden ilgili sayfanın öğelerini kesiyoruz.
    List<String> allData = List.generate(_totalItems, (index) => 'Öğe ${index + 1}');

    int startIndex = page * _pageSize;
    int endIndex = (startIndex + _pageSize).clamp(0, allData.length); // Veri dışına çıkmayı engelle

    setState(() {
      _currentItems = allData.sublist(startIndex, endIndex);
      print('Sayfa ${page + 1} için veriler yüklendi. (Başlangıç: $startIndex, Bitiş: $endIndex)');
      print('Gösterilen Öğeler: $_currentItems');
    });
  }

  // --- Sayfalama Butonlarının Geri Çağrımları ---

  void _onPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _fetchDataForPage(_currentPage); // Yeni sayfanın verilerini getir
    }
  }

  void _onNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
      _fetchDataForPage(_currentPage); // Yeni sayfanın verilerini getir
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayfalı Tablo Örneği'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _currentItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_currentItems[index]),
                  subtitle: Text('Bu öğe sayfa ${_currentPage + 1} üzerinde.'),
                );
              },
            ),
          ),
          // --- PaginationControls widget'ının kullanımı ---
          PaginationControls(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPrevious: _onPreviousPage, // Geri butonu callback'i
            onNext: _onNextPage,       // İleri butonu callback'i
          ),
        ],
      ),
    );
  }
}