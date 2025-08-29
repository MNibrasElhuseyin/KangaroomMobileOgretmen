import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Uyku/get_uyku.dart';

class UykuCardList extends StatelessWidget {
  final List<GetUykuModel> students;
  final int rowsPerPage;
  final int currentPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Function(int, int) onStatusSelected;

  const UykuCardList({
    super.key,
    required this.students,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onPrevious,
    required this.onNext,
    required this.onStatusSelected,
  });

  List<GetUykuModel> get paginatedStudents {
    final startIndex = currentPage * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, students.length);
    return students.sublist(startIndex, endIndex);
  }

  Widget _buildStatusButton(BuildContext context, IconData icon, int durumValue, int selectedDurum, int globalIndex, Color color) {
    final isSelected = selectedDurum == durumValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onStatusSelected(globalIndex, durumValue),
        child: Container(
          height: 50, // Reduced from 60
          margin: const EdgeInsets.symmetric(horizontal: 2), // Reduced from 4
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 2 : 1, // Reduced border width when selected
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                spreadRadius: 0.5, // Reduced from 1
                blurRadius: 3, // Reduced from 4
                offset: const Offset(0, 1), // Reduced from (0, 2)
              ),
            ]
                : null,
          ),
          child: Center(
            child: Icon(
              icon,
              color: isSelected ? color : Colors.grey[400],
              size: 28, // Reduced from 32
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
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.bedtime, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Henüz veri bulunmuyor',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              : ListView.separated(
            itemCount: currentStudents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6), // Reduced from 8
            itemBuilder: (context, localIndex) {
              final student = currentStudents[localIndex];
              final name = student.modelAdSoyad;
              final selectedDurum = student.durum;

              // Global index hesaplaması
              final globalIndex = (currentPage * rowsPerPage) + localIndex;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Reduced from 12
                ),
                elevation: 3, // Reduced from 4
                shadowColor: Colors.grey.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 6), // Reduced from 8
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Reduced from 16
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatusButton(context, Icons.cancel, 0, selectedDurum, globalIndex, Colors.red),
                          _buildStatusButton(context, Icons.self_improvement, 1, selectedDurum, globalIndex, Colors.orange),
                          _buildStatusButton(context, Icons.bedtime, 2, selectedDurum, globalIndex, Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: currentPage > 0 ? onPrevious : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("← Önceki"),
            ),
            const SizedBox(width: 12),
            Text(
              'Sayfa ${currentPage + 1}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: (currentPage + 1) * rowsPerPage < students.length ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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