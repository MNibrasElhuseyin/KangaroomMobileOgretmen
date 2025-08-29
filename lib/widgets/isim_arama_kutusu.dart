import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AramaKutusuWidget extends StatefulWidget {
  const AramaKutusuWidget({super.key});

  @override
  State<AramaKutusuWidget> createState() => _AramaKutusuWidgetState();
}

class _AramaKutusuWidgetState extends State<AramaKutusuWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<Map<String, dynamic>> _aramaSonuclari = [];

  Future<void> _veriAra(String sorgu) async {
    if (sorgu.length < 3) return;

    try {
      final uri = Uri.parse('https://api.ornek.com/arama?isim=$sorgu'); // 🔁 API adresini güncelle
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> veri = json.decode(response.body);
        setState(() {
          _aramaSonuclari = veri
              .map((item) => {
            'ad': item['ad'],
            'soyad': item['soyad'],
          })
              .toList();
        });
      } else {
        debugPrint('Hata: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('İstek hatası: $e');
    }
  }

  void _onSearchChanged(String sorgu) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _veriAra(sorgu);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: _onSearchChanged,
          decoration: const InputDecoration(
            labelText: 'İsim Ara',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ..._aramaSonuclari.map((kisi) {
          final adSoyad = '${kisi['ad']} ${kisi['soyad']}';
          return ListTile(
            title: Text(adSoyad),
            onTap: () {
              debugPrint('Seçildi: $adSoyad');
              // buraya seçildiğinde yapılacak işlem ekleyebilirsin
            },
          );
        }).toList(),
      ],
    );
  }
}
