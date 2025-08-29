import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/screens/sinif_takip_pages/sinif_takip_controller.dart';

class YoklamaCardList extends StatefulWidget {
  final List<List<String>> students;
  final int rowsPerPage;
  final int currentPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final SinifTakipController controller;

  const YoklamaCardList({
    super.key,
    required this.students,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onPrevious,
    required this.onNext,
    required this.controller,
  });

  @override
  State<YoklamaCardList> createState() => _YoklamaCardListState();
}

class _YoklamaCardListState extends State<YoklamaCardList> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    setState(() {});
  }

  List<List<String>> get paginatedStudents {
    final startIndex = widget.currentPage * widget.rowsPerPage;
    final endIndex = (startIndex + widget.rowsPerPage).clamp(0, widget.students.length);
    return widget.students.sublist(startIndex, endIndex);
  }

  int get totalPages => (widget.students.length / widget.rowsPerPage).ceil();

  bool _isPresent(String durum) {
    return durum.toLowerCase() == 'geldi' || durum.toLowerCase() == 'present';
  }

  Color _getStatusColor(String durum) {
    return _isPresent(durum) ? Colors.green : Colors.red;
  }

  IconData _getStatusIcon(String durum) {
    return _isPresent(durum) ? Icons.check_circle : Icons.cancel;
  }

  String _getStatusText(String durum) {
    return _isPresent(durum) ? 'Geldi' : 'Gelmedi';
  }

  void _toggleAttendance(int studentIndex, String currentStatus) {
    final newValue = !_isPresent(currentStatus);
    widget.controller.updateAttendanceStatus(studentIndex, newValue);
  }

  Widget _buildSelectAllSection() {
    final currentStudents = paginatedStudents;
    if (currentStudents.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.select_all,
            color: Colors.deepPurple,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Bu sayfadaki tüm öğrencileri seç',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple.shade700,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: widget.controller.areAllCurrentPageSelected(),
            onChanged: (value) {
              widget.controller.toggleSelectAllCurrentPage(value);
            },
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStudents = paginatedStudents;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Column(
      children: [
        // Tümünü seç bölümü
        _buildSelectAllSection(),

        Expanded(
          child: currentStudents.isEmpty
              ? Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Henüz öğrenci bulunmuyor',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: currentStudents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final student = currentStudents[index];
              final studentName = student[0]; // Öğrenci Adı
              final attendanceStatusValue = student[1]; // Yoklama Durumu
              final actualIndex = (widget.currentPage * widget.rowsPerPage) + index;
              final currentAttendance = widget.controller.attendanceStatus[actualIndex] ?? _isPresent(attendanceStatusValue);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                shadowColor: Colors.grey.withOpacity(0.2),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: InkWell(
                  onTap: () => _toggleAttendance(actualIndex, attendanceStatusValue),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    child: Row(
                      children: [
                        // Öğrenci Avatar
                        Container(
                          width: isSmallScreen ? 40 : 50,
                          height: isSmallScreen ? 40 : 50,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 25),
                            border: Border.all(
                              color: Colors.deepPurple.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.deepPurple,
                            size: isSmallScreen ? 20 : 28,
                          ),
                        ),

                        SizedBox(width: isSmallScreen ? 12 : 16),

                        // Öğrenci Bilgileri
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentName,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    currentAttendance ? Icons.check_circle : Icons.cancel,
                                    size: isSmallScreen ? 14 : 16,
                                    color: currentAttendance ? Colors.green : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      currentAttendance ? 'Geldi' : 'Gelmedi',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        color: currentAttendance ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Yoklama Durumu Toggle
                        Container(
                          width: isSmallScreen ? 50 : 60,
                          height: isSmallScreen ? 30 : 35,
                          decoration: BoxDecoration(
                            color: (currentAttendance ? Colors.green : Colors.red).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (currentAttendance ? Colors.green : Colors.red).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: FittedBox(
                            child: Switch(
                              value: currentAttendance,
                              onChanged: (value) {
                                widget.controller.updateAttendanceStatus(actualIndex, value);
                              },
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.red,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Sayfalama Kontrolleri
        if (widget.students.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: widget.currentPage > 0 ? widget.onPrevious : null,
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
                'Sayfa ${widget.currentPage + 1}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: widget.currentPage < totalPages - 1 ? widget.onNext : null,
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

        const SizedBox(height: 8),
      ],
    );
  }
}