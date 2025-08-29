/* mport 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_karne.dart';
import 'karne_karti_widget.dart';

class KarneDonemSection extends StatelessWidget {
  final int donem;
  final List<GetOgrenciKarne> veriler;

  const KarneDonemSection({
    super.key,
    required this.donem,
    required this.veriler,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$donem. Dönem",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 8),
        ...veriler.map((v) => KarneKartiWidget(karne: v)).toList(),
        const SizedBox(height: 20),
      ],
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/karne/get_gelisim_list.dart';
import 'karne_karti_widget.dart';

class KarneDonemSection extends StatelessWidget {
  final int donem; // 1 veya 2
  final Map<int, String> gelisimTurMap; // turId -> ad
  final Map<int, List<GetGelisimListModel>> gelisimListMap; // turId -> maddeler
  final Map<String, int> selectedScoresForDonem; // gelisimAlani -> puan

  const KarneDonemSection({
    super.key,
    required this.donem,
    required this.gelisimTurMap,
    required this.gelisimListMap,
    required this.selectedScoresForDonem,
  });

  @override
  Widget build(BuildContext context) {
    final entries = gelisimTurMap.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$donem. Dönem',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 8),
        ...entries.map((e) {
          final turId = e.key;
          final alanAd = e.value;
          final maddeler =
              gelisimListMap[turId]?.map((x) => x.ad).toList() ??
              const <String>[];
          return KarneKartiWidget(
            alan: alanAd,
            maddeler: maddeler,
            selectedScores: selectedScoresForDonem,
          );
        }).toList(),
        const SizedBox(height: 20),
      ],
    );
  }
}
