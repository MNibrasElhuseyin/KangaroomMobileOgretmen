import 'package:flutter/material.dart';

class KiyafetTalepCardList extends StatelessWidget {
  final List<List<String>> talepData;
  final int rowsPerPage;
  final int currentPage;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const KiyafetTalepCardList({
    super.key,
    required this.talepData,
    required this.rowsPerPage,
    required this.currentPage,
    required this.onPrevious,
    required this.onNext,
  });

  List<List<String>> get paginatedData {
    final startIndex = currentPage * rowsPerPage;
    final endIndex = (startIndex + rowsPerPage).clamp(0, talepData.length);
    return talepData.sublist(startIndex, endIndex);
  }

  List<String> _extractKiyafetTurleri(String icerik) {
    List<String> turler = [];
    if (icerik.contains('Üst Çamaşır')) turler.add('Üst Çamaşır');
    if (icerik.contains('Alt Çamaşır')) turler.add('Alt Çamaşır');
    if (icerik.contains('Üst Kıyafet')) turler.add('Üst Kıyafet');
    if (icerik.contains('Alt Kıyafet')) turler.add('Alt Kıyafet');
    return turler;
  }

  String _extractAciklama(String icerik) {
    final regex = RegExp(r'\(([^)]+)\)');
    final matches = regex.allMatches(icerik);
    if (matches.isNotEmpty) {
      return matches.last.group(1) ?? '';
    }
    return '';
  }

  Widget _buildKiyafetTypeItem(String label, bool isSelected, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? color : Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? color : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = paginatedData;

    return Column(
      children: [
        Expanded(
          child: currentData.isEmpty
              ? Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.checkroom_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Henüz kıyafet talebi bulunmuyor',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yukarıdaki formu kullanarak kıyafet talebi oluşturabilirsiniz.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
              : ListView.separated(
            itemCount: currentData.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final talepBilgisi = currentData[index];
              final kiyafetTurleri = _extractKiyafetTurleri(talepBilgisi[2]);
              final aciklama = _extractAciklama(talepBilgisi[2]);

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
                                talepBilgisi[0],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple[800],
                                ),
                              ),
                            ),
                            Text(
                              talepBilgisi[1],
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (aciklama.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            aciklama,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      if (kiyafetTurleri.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (kiyafetTurleri.contains('Üst Kıyafet'))
                              _buildKiyafetTypeItem(
                                'Üst Kıyafet',
                                true,
                                Icons.checkroom,
                                Colors.blue[600]!,
                              ),
                            if (kiyafetTurleri.contains('Alt Kıyafet'))
                              _buildKiyafetTypeItem(
                                'Alt Kıyafet',
                                true,
                                Icons.content_cut,
                                Colors.green[600]!,
                              ),
                            if (kiyafetTurleri.contains('Üst Çamaşır'))
                              _buildKiyafetTypeItem(
                                'Üst Çamaşır',
                                true,
                                Icons.dry_cleaning,
                                Colors.purple[600]!,
                              ),
                            if (kiyafetTurleri.contains('Alt Çamaşır'))
                              _buildKiyafetTypeItem(
                                'Alt Çamaşır',
                                true,
                                Icons.local_laundry_service,
                                Colors.orange[600]!,
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
              onPressed: (currentPage + 1) * rowsPerPage < talepData.length ? onNext : null,
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