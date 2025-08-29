import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/sinifTakip/DuyguDurum/get_duygu_durum.dart';

class DuyguDurumCardList extends StatelessWidget {
  final List<GetDuyguDurumModel> students;
  final int rowsPerPage;
  final int currentPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Function(int, int) onEmojiSelected;

  const DuyguDurumCardList({
    super.key,
    required this.students,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onPrevious,
    required this.onNext,
    required this.onEmojiSelected,
  });

  List<GetDuyguDurumModel> get paginatedStudents {
    final startIndex = currentPage * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, students.length);
    return students.sublist(startIndex, endIndex);
  }

  Widget _buildEmojiButton(BuildContext context, IconData icon, int durumValue, int selectedDurum, int globalIndex, Color color) {
    final isSelected = selectedDurum == durumValue;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Global index hesaplaması: currentPage * rowsPerPage + local index
          onEmojiSelected(globalIndex, durumValue);
        },
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? color.withOpacity(0.2) : Colors.grey[100],
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 3 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: color.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Center(
            child: Icon(
              icon,
              color: isSelected ? color : Colors.grey[400],
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStudents = paginatedStudents;

    return Column(
      children: [
        Expanded(
          child: currentStudents.isEmpty
              ? Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.mood, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  'Henüz veri bulunmuyor',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              : ListView.separated(
            itemCount: currentStudents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, localIndex) {
              final student = currentStudents[localIndex];
              final name = student.modelAdSoyad;
              final selectedDurum = student.durum;

              // Global index hesaplaması
              final globalIndex = (currentPage * rowsPerPage) + localIndex;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                shadowColor: Colors.grey.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildEmojiButton(context, Icons.sentiment_very_dissatisfied, 0, selectedDurum, globalIndex, Colors.red),
                          _buildEmojiButton(context, Icons.sentiment_dissatisfied, 1, selectedDurum, globalIndex, Colors.orange),
                          _buildEmojiButton(context, Icons.sentiment_neutral, 2, selectedDurum, globalIndex, Colors.yellow),
                          _buildEmojiButton(context, Icons.sentiment_satisfied, 3, selectedDurum, globalIndex, Colors.lightGreen),
                          _buildEmojiButton(context, Icons.sentiment_very_satisfied, 4, selectedDurum, globalIndex, Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: currentPage > 0 ? onPrevious : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text("← Önceki"),
            ),
            const SizedBox(width: 8),
            Text(
              'Sayfa ${currentPage + 1}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: (currentPage + 1) * rowsPerPage < students.length ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text("Sonraki →"),
            ),
          ],
        ),
      ],
    );
  }
}