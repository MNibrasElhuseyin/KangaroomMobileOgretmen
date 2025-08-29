import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/get_ders_resim_video.dart';

class DersResimleriCardList extends StatelessWidget {
  final List<GetDersResimVideoModel> tableData;
  final int rowsPerPage;
  final int currentPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const DersResimleriCardList({
    super.key,
    required this.tableData,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onPrevious,
    required this.onNext,
  });

  List<GetDersResimVideoModel> get paginatedData {
    final startIndex = currentPage * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, tableData.length);
    return tableData.sublist(startIndex, endIndex);
  }

  void _showDetailDialog(BuildContext context, GetDersResimVideoModel rowData) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final dialogWidth = isLargeScreen ? screenWidth * 0.5 : screenWidth * 0.9;
    final fontScale = isLargeScreen ? 1.2 : 1.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: 16,
          ),
          content: Container(
            width: dialogWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('Öğrenci:', rowData.modelAdSoyad, fontScale),
                  _buildDetailRow('Ders:', rowData.modelDersAd, fontScale),
                  _buildDetailRow('Açıklama:', rowData.modelDersAciklama, fontScale),
                  _buildDetailRow('Dosya Sayısı:', rowData.modelDosyaSayi.toString(), fontScale),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
              ),
              child: Text(
                'Kapat',
                style: TextStyle(fontSize: 14 * fontScale),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, double fontScale) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontSize: 13 * fontScale,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13 * fontScale,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int dosyaSayisi) {
    return dosyaSayisi > 0 ? Colors.green : Colors.grey;
  }

  IconData _getStatusIcon(int dosyaSayisi) {
    return dosyaSayisi > 0 ? Icons.check_circle : Icons.help;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final fontScale = isLargeScreen ? 1.2 : 1.0;
    final currentData = paginatedData;

    return Column(
      children: [
        Expanded(
          child: currentData.isEmpty
              ? Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: isLargeScreen ? 80 : 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: isLargeScreen ? 20 : 16),
                  Text(
                    'Henüz ders resmi bulunmuyor',
                    style: TextStyle(
                      fontSize: 16 * fontScale,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Yukarıdaki formu kullanarak ders resmi yükleyebilirsiniz.',
                    style: TextStyle(
                      fontSize: 14 * fontScale,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
              : ListView.separated(
            itemCount: currentData.length,
            separatorBuilder: (_, __) => SizedBox(height: isLargeScreen ? 12 : 8),
            itemBuilder: (context, index) {
              final rowData = currentData[index];
              final status = rowData.modelDosyaSayi;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.3),
                margin: EdgeInsets.symmetric(
                  vertical: isLargeScreen ? 12 : 8,
                  horizontal: screenWidth * 0.02,
                ),
                child: InkWell(
                  onTap: () => _showDetailDialog(context, rowData),
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isLargeScreen ? 20 : 16,
                      vertical: isLargeScreen ? 12 : 8,
                    ),
                    leading: Container(
                      width: isLargeScreen ? 60 : 50,
                      height: isLargeScreen ? 60 : 50,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getStatusColor(status).withOpacity(0.3),
                        ),
                      ),
                      child: Icon(
                        _getStatusIcon(status),
                        color: _getStatusColor(status),
                        size: isLargeScreen ? 28 : 24,
                      ),
                    ),
                    title: Text(
                      'Ders: ${rowData.modelDersAd}',
                      style: TextStyle(
                        fontSize: 14 * fontScale,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Öğrenci: ${rowData.modelAdSoyad}',
                          style: TextStyle(
                            fontSize: 12 * fontScale,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Açıklama: ${rowData.modelDersAciklama}',
                          style: TextStyle(
                            fontSize: 12 * fontScale,
                            color: Colors.grey[600],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isLargeScreen ? 10 : 8,
                                vertical: isLargeScreen ? 3 : 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getStatusColor(status).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                status > 0 ? 'Yüklendi' : 'Yüklenmedi',
                                style: TextStyle(
                                  fontSize: 11 * fontScale,
                                  color: _getStatusColor(status),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '$status resim',
                              style: TextStyle(
                                fontSize: 11 * fontScale,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.visibility,
                      color: Colors.deepPurple.withOpacity(0.6),
                      size: isLargeScreen ? 24 : 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: isLargeScreen ? 12 : 8),
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
                padding: EdgeInsets.symmetric(
                  vertical: isLargeScreen ? 14 : 12,
                  horizontal: isLargeScreen ? 16 : 12,
                ),
              ),
              child: Text(
                "← Önceki",
                style: TextStyle(fontSize: 14 * fontScale),
              ),
            ),
            SizedBox(width: isLargeScreen ? 16 : 12),
            Text(
              'Sayfa ${currentPage + 1}',
              style: TextStyle(
                fontSize: 14 * fontScale,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: isLargeScreen ? 16 : 12),
            ElevatedButton(
              onPressed: (currentPage + 1) * rowsPerPage < tableData.length ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isLargeScreen ? 14 : 12,
                  horizontal: isLargeScreen ? 16 : 12,
                ),
              ),
              child: Text(
                "Sonraki →",
                style: TextStyle(fontSize: 14 * fontScale),
              ),
            ),
          ],
        ),
      ],
    );
  }
}