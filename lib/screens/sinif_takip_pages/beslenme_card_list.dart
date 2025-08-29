import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/sinifTakip/Beslenme/get_beslenme.dart';

class BeslenmeCardList extends StatelessWidget {
  final List<GetBeslenmeModel> students;
  final int rowsPerPage;
  final int currentPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Function(int, int) onStatusSelected;

  const BeslenmeCardList({
    super.key,
    required this.students,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onPrevious,
    required this.onNext,
    required this.onStatusSelected,
  });

  List<GetBeslenmeModel> get paginatedStudents {
    final startIndex = currentPage * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, students.length);
    return students.sublist(startIndex, endIndex);
  }

  Widget _buildStatusButton(
      BuildContext context,
      int statusValue,
      int selectedStatus,
      int studentIndex, // Bu parametre öğrenci index'i olmalı, buton index'i değil
      ) {
    final isSelected = selectedStatus == statusValue;
    Color buttonColor;
    String statusText;
    double fillFraction;

    switch (statusValue) {
      case 0:
        buttonColor = Colors.red;
        statusText = 'Hiç\nYemedi';
        fillFraction = 0.0;
        break;
      case 1:
        buttonColor = Colors.orange;
        statusText = 'Çeyrek\nPorsiyon';
        fillFraction = 0.25;
        break;
      case 2:
        buttonColor = Colors.yellow;
        statusText = 'Yarım\nPorsiyon';
        fillFraction = 0.5;
        break;
      case 3:
        buttonColor = Colors.green;
        statusText = 'Tam\nPorsiyon';
        fillFraction = 1.0;
        break;
      default:
        buttonColor = Colors.grey;
        statusText = 'Bilinmiyor';
        fillFraction = 0.0;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Callback'i çağır - studentIndex ve statusValue'yu gönder
          onStatusSelected(studentIndex, statusValue);
        },
        child: Container(
          height: 70, // Reduced from 100
          margin: const EdgeInsets.symmetric(horizontal: 2), // Reduced from 4
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40, // Reduced from 50
                height: 40, // Reduced from 50
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  border: Border.all(
                    color: isSelected ? buttonColor : Colors.grey[300]!,
                    width:
                    isSelected
                        ? 2
                        : 1, // Reduced border width when selected
                  ),
                  boxShadow:
                  isSelected
                      ? [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.3),
                      spreadRadius: 0.5, // Reduced from 1
                      blurRadius: 3, // Reduced from 4
                      offset: const Offset(0, 1), // Reduced from (0, 2)
                    ),
                  ]
                      : null,
                ),
                child: CustomPaint(
                  painter: CircleFillPainter(
                    fillFraction,
                    buttonColor,
                    isSelected,
                  ),
                  child: Center(
                    child: Text(
                      fillFraction == 0.0 ? 'X' : '',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Reduced from 16
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2), // Reduced from 4
              Text(
                statusText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8, // Reduced from 10
                  fontWeight: FontWeight.w600,
                  color: isSelected ? buttonColor : Colors.grey[600],
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
          child:
          currentStudents.isEmpty
              ? Container(
            padding: const EdgeInsets.all(24), // Reduced from 32
            child: Column(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 48,
                  color: Colors.grey,
                ), // Reduced from 64
                const SizedBox(height: 12), // Reduced from 16
                Text(
                  'Henüz veri bulunmuyor',
                  style: TextStyle(
                    fontSize: 14, // Reduced from 16
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              : ListView.separated(
            itemCount: currentStudents.length,
            separatorBuilder:
                (_, __) => const SizedBox(height: 6), // Reduced from 8
            itemBuilder: (context, index) {
              final student = currentStudents[index];
              final name = student.modelAdSoyad;
              final ogun = student.modelOgun;
              final selectedStatus = student.durum ?? 0;

              // Gerçek öğrenci index'ini hesapla (pagination için)
              final actualStudentIndex = (currentPage * rowsPerPage) + index;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // Reduced from 12
                ),
                elevation: 3, // Reduced from 4
                shadowColor: Colors.grey.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(
                  vertical: 6,
                ), // Reduced from 8
                child: Padding(
                  padding: const EdgeInsets.all(
                    12.0,
                  ), // Reduced from 16
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 14, // Reduced from 16
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ), // Reduced from (8, 4)
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                6,
                              ), // Reduced from 8
                            ),
                            child: Text(
                              ogun,
                              style: TextStyle(
                                fontSize: 10, // Reduced from 12
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Reduced from 12
                      Row(
                        children: [
                          _buildStatusButton(
                            context,
                            0,
                            selectedStatus,
                            actualStudentIndex, // Gerçek öğrenci index'ini gönder
                          ),
                          _buildStatusButton(
                            context,
                            1,
                            selectedStatus,
                            actualStudentIndex,
                          ),
                          _buildStatusButton(
                            context,
                            2,
                            selectedStatus,
                            actualStudentIndex,
                          ),
                          _buildStatusButton(
                            context,
                            3,
                            selectedStatus,
                            actualStudentIndex,
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
        const SizedBox(height: 6), // Reduced from 8
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: currentPage > 0 ? onPrevious : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6), // Reduced from 8
                ),
              ),
              child: const Text("← Önceki"),
            ),
            const SizedBox(width: 8), // Reduced from 12
            Text(
              'Sayfa ${currentPage + 1}',
              style: TextStyle(
                fontSize: 12, // Reduced from 14
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8), // Reduced from 12
            ElevatedButton(
              onPressed:
              (currentPage + 1) * rowsPerPage < students.length
                  ? onNext
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6), // Reduced from 8
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

class CircleFillPainter extends CustomPainter {
  final double fillFraction;
  final Color fillColor;
  final bool isSelected;

  CircleFillPainter(this.fillFraction, this.fillColor, this.isSelected);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
    Paint()
      ..color = isSelected ? fillColor : Colors.grey[400]!
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (fillFraction > 0.0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * fillFraction,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

const double pi = 3.1415926535897932;