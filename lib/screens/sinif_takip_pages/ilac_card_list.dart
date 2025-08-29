import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Ilac/get_ilac.dart';

class IlacCardList extends StatelessWidget {
  final List<GetIlacModel> students;
  final int rowsPerPage;
  final int currentPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Function(int, int) onStatusSelected; // Durum ID'si ile güncelleme

  const IlacCardList({
    super.key,
    required this.students,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onPrevious,
    required this.onNext,
    required this.onStatusSelected,
  });

  List<GetIlacModel> get paginatedStudents {
    final startIndex = currentPage * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, students.length);
    return students.sublist(startIndex, endIndex);
  }

  Widget _buildStatusButton(BuildContext context, int statusValue, int selectedStatus, int studentIndex) {
    final isSelected = selectedStatus == statusValue;
    Color buttonColor;
    String statusText;
    IconData statusIcon;

    switch (statusValue) {
      case 0:
        buttonColor = Colors.red;
        statusText = 'İçmedi';
        statusIcon = Icons.close;
        break;
      case 1:
        buttonColor = Colors.green;
        statusText = 'İçti';
        statusIcon = Icons.check;
        break;
      default:
        buttonColor = Colors.grey;
        statusText = 'Bilinmiyor';
        statusIcon = Icons.help_outline;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Butona tıklandığında callback fonksiyonunu çağır
          onStatusSelected(studentIndex, statusValue);
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? buttonColor : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? buttonColor : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: buttonColor.withOpacity(0.2),
                spreadRadius: 0.5,
                blurRadius: 3,
                offset: const Offset(0, 1),
              )
            ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                statusIcon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                statusText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[600],
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
              children: [
                Icon(Icons.medication, size: 64, color: Colors.grey),
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
              final ilac = student.modelIlac;
              final saat = student.modelSaat;
              final selectedStatus = student.durum;

              // Global index hesapla (pagination için)
              final globalIndex = currentPage * rowsPerPage + index;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.medication, size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      ilac,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time, size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(
                                  saat,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildStatusButton(context, 0, selectedStatus, globalIndex),
                          _buildStatusButton(context, 1, selectedStatus, globalIndex),
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