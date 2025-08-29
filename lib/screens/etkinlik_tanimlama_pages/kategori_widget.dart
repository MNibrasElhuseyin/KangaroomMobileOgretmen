import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KategoriWidget extends StatefulWidget {
  final Function(String?) onKategoriSelected;
  const KategoriWidget({super.key, required this.onKategoriSelected});

  @override
  State<KategoriWidget> createState() => _KategoriWidgetState();
}

class _KategoriWidgetState extends State<KategoriWidget> {
  List<String> kategoriler = [];
  String? secilenKategori;

  @override
  void initState() {
    super.initState();
    fetchKategoriler();
  }

  Future<void> fetchKategoriler() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.example.com/kategoriler'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          kategoriler = List<String>.from(data['Sınıf']);
        });
      } else {
        throw Exception('Sınıflar yüklenmedi');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sınıf verileri alınamadı')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: secilenKategori,
      hint: const Text('Sınıf Seç', style: TextStyle(color: Colors.deepPurple)),
      items:
          kategoriler
              .map((k) => DropdownMenuItem(value: k, child: Text(k)))
              .toList(),
      onChanged: (deger) {
        setState(() {
          secilenKategori = deger;
        });
        widget.onKategoriSelected(deger);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue.shade100),
        ),
        filled: true,
        fillColor: const Color(0xFFFCF7FA),
      ),
    );
  }
}
