/* import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_karne.dart';
import 'package:kangaroom_mobile/widgets/app_constant.dart';

class KarneKartiWidget extends StatelessWidget {
  final GetOgrenciKarne karne;
  final List<String> emojiler = const ["😐", "😕", "🙂", "❤️"];

  KarneKartiWidget({super.key, required this.karne});

  @override
  Widget build(BuildContext context) {
    final int selected = karne.puan - 1;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji satırı
            Row(
              children: List.generate(emojiler.length, (i) {
                final bool isSelected = i == selected;
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: isSelected
                        ? Border.all(
                      color: AppConstants.accentColor,
                      width: 2,
                    )
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    emojiler[i],
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }),
            ),
            const SizedBox(height: 6),
            Text(
              karne.modelGelisimTur,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Text(karne.modelGelisimAlani),
          ],
        ),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/screens/ogrenci_analiz_pages/karne/karne_card.dart';

class KarneKartiWidget extends StatelessWidget {
  final String alan;
  final List<String> maddeler;
  final Map<String, int> selectedScores;

  const KarneKartiWidget({
    super.key,
    required this.alan,
    required this.maddeler,
    required this.selectedScores,
  });

  @override
  Widget build(BuildContext context) {
    return KarneCard(
      alan: alan,
      maddeler: maddeler,
      selectedScores: selectedScores,
    );
  }
}
