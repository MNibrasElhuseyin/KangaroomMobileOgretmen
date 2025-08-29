import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';

class YoklamaTabloBaslik extends StatelessWidget {
  const YoklamaTabloBaslik({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text('Tarih')),
          Expanded(flex: 2, child: Text('Durum')),
        ],
      ),
    );
  }
}

class YoklamaListeWidget extends StatelessWidget {
  const YoklamaListeWidget({super.key});

  final List<Map<String, String>> yoklamaListesi = const [
    {'tarih': '10.07.2025', 'durum': 'Gelmedi'},
    {'tarih': '17.07.2025', 'durum': 'Geldi'},
    {'tarih': '18.07.2025', 'durum': 'Gelmedi'},
    {'tarih': '19.07.2025', 'durum': 'Gelmedi'},
    {'tarih': '22.07.2025', 'durum': 'Geldi'},
    {'tarih': '25.07.2025', 'durum': 'Gelmedi'},
    {'tarih': '27.07.2025', 'durum': 'Gelmedi'},
    {'tarih': '28.07.2025', 'durum': 'Gelmedi'},
    {'tarih': '08.07.2025', 'durum': 'Geldi'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: yoklamaListesi.length,
      itemBuilder: (context, index) {
        final item = yoklamaListesi[index];
        final bool geldi = item['durum'] == 'Geldi';

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(item['tarih']!)),
              Expanded(
                flex: 2,
                child: Text(
                  item['durum']!,
                  style: TextStyle(
                    color: geldi ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
