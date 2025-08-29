import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_analiz.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';

class OgrenciKartList extends StatelessWidget {
  final List<GetOgrenciAnaliz> ogrenciler;
  final void Function(int) onShow;

  const OgrenciKartList({
    super.key,
    required this.ogrenciler,
    required this.onShow,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ogrenciler.length,
      itemBuilder: (context, index) {
        final ogrenci = ogrenciler[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(ogrenci.modelAdSoyad),
            subtitle: Text(ogrenci.modelSinif),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.accentColor,
              ),
              onPressed: () => onShow(index),
              child: const Text("Göster"),
            ),
          ),
        );
      },
    );
  }
}