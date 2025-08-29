import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Kiyafet/get_kiyafet.dart';

class KiyafetCardList extends StatelessWidget {
  final List<GetKiyafetModel> students;
  final int rowsPerPage;
  final int currentPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Function(int, String, bool) onItemSelected; // studentIndex, itemType, isSelected

  const KiyafetCardList({
    super.key,
    required this.students,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onPrevious,
    required this.onNext,
    required this.onItemSelected,
  });

  List<GetKiyafetModel> get paginatedStudents {
    final startIndex = currentPage * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, students.length);
    return students.sublist(startIndex, endIndex);
  }

  Widget _buildClothingItem({
    required String itemType,
    required String label,
    required bool isSelected,
    required VoidCallback onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? color : Colors.grey[300]!,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onChanged,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: isSelected ? color : Colors.grey[400]!,
                    width: 1.5,
                  ),
                  color: isSelected ? color : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                )
                    : null,
              ),
              const SizedBox(width: 6),
              Icon(
                icon,
                size: 14,
                color: isSelected ? color : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? color : Colors.grey[700],
                  ),
                ),
              ),
            ],
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
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.checkroom, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
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
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final student = currentStudents[index];
              final name = student.modelAdSoyad;

              // Gerçek öğrenci index'ini hesapla (pagination için)
              final actualStudentIndex = (currentPage * rowsPerPage) + index;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                shadowColor: Colors.grey.withOpacity(0.15),
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Öğrenci adı - daha kompakt
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.deepPurple[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.deepPurple[700],
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Kıyafet seçenekleri - 2x2 grid (daha kompakt)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildClothingItem(
                                  itemType: 'ustKiyafet',
                                  label: 'Üst Kıyafet',
                                  isSelected: student.ustKiyafet == 1,
                                  onChanged: () => onItemSelected(
                                    actualStudentIndex, // Gerçek index'i gönder
                                    'ustKiyafet',
                                    student.ustKiyafet != 1,
                                  ),
                                  icon: Icons.checkroom,
                                  color: Colors.blue[600]!,
                                ),
                                _buildClothingItem(
                                  itemType: 'ustCamasir',
                                  label: 'Üst Çamaşır',
                                  isSelected: student.ustCamasir == 1,
                                  onChanged: () => onItemSelected(
                                    actualStudentIndex, // Gerçek index'i gönder
                                    'ustCamasir',
                                    student.ustCamasir != 1,
                                  ),
                                  icon: Icons.dry_cleaning,
                                  color: Colors.purple[600]!,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              children: [
                                _buildClothingItem(
                                  itemType: 'altKiyafet',
                                  label: 'Alt Kıyafet',
                                  isSelected: student.altKiyafet == 1,
                                  onChanged: () => onItemSelected(
                                    actualStudentIndex, // Gerçek index'i gönder
                                    'altKiyafet',
                                    student.altKiyafet != 1,
                                  ),
                                  icon: Icons.content_cut,
                                  color: Colors.green[600]!,
                                ),
                                _buildClothingItem(
                                  itemType: 'altCamasir',
                                  label: 'Alt Çamaşır',
                                  isSelected: student.altCamasir == 1,
                                  onChanged: () => onItemSelected(
                                    actualStudentIndex, // Gerçek index'i gönder
                                    'altCamasir',
                                    student.altCamasir != 1,
                                  ),
                                  icon: Icons.local_laundry_service,
                                  color: Colors.orange[600]!,
                                ),
                              ],
                            ),
                          ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                "← Önceki",
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Sayfa ${currentPage + 1}',
              style: TextStyle(
                fontSize: 12,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                "Sonraki →",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}