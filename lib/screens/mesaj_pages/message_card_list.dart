import 'package:flutter/material.dart';
import '../../models/mesaj/get_mesaj.dart';
import '../../models/mesaj/get_ogrenci_list_all.dart';

class MessageCardList extends StatefulWidget {
  final List<GetMesajModel> messages;
  final int rowsPerPage;
  final int? filterOgrenciId;
  final List<GetOgrenciListAllModel> ogrenciler;

  const MessageCardList({
    super.key,
    required this.messages,
    required this.rowsPerPage,
    required this.filterOgrenciId,
    required this.ogrenciler,
  });

  @override
  State<MessageCardList> createState() => _MessageCardListState();
}

class _MessageCardListState extends State<MessageCardList> {
  int currentPage = 0;

  List<GetMesajModel> get _filteredMessages {
    List<GetMesajModel> filtered = widget.messages;
    if (widget.filterOgrenciId != null && widget.filterOgrenciId != -1) {
      final ogrenci = widget.ogrenciler.firstWhere(
        (o) => o.modelID == widget.filterOgrenciId,
        orElse: () => widget.ogrenciler.first,
      );
      final adSoyad = ogrenci.modelAdSoyad;
      filtered =
          widget.messages
              .where(
                (msg) =>
                    msg.modelKimdenAdSoyad == adSoyad ||
                    msg.modelKimeAdSoyad == adSoyad,
              )
              .toList();
    }
    return filtered;
  }

  List<GetMesajModel> get paginatedMessages {
    final filtered = _filteredMessages;
    int startIndex = currentPage * widget.rowsPerPage;
    if (startIndex >= filtered.length) startIndex = 0;
    final endIndex = (startIndex + widget.rowsPerPage).clamp(
      0,
      filtered.length,
    );
    return filtered.sublist(startIndex, endIndex);
  }

  int get totalPages => (_filteredMessages.length / widget.rowsPerPage).ceil();

  void _goToPrevious() {
    setState(() {
      if (currentPage > 0) currentPage--;
    });
  }

  void _goToNext() {
    setState(() {
      if ((currentPage + 1) < totalPages) currentPage++;
    });
  }

  @override
  void didUpdateWidget(covariant MessageCardList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Filtre değişirse sayfa başa dönsün
    if (oldWidget.filterOgrenciId != widget.filterOgrenciId) {
      setState(() {
        currentPage = 0;
      });
    }
  }

  void _showDetailDialog(BuildContext context, GetMesajModel msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.message, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text(
                'Mesaj Detayı',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Tarih:', msg.modelTarih),
                _buildDetailRow('Gönderen:', msg.modelKimdenAdSoyad),
                _buildDetailRow('Alıcı:', msg.modelKimeAdSoyad),
                SizedBox(height: 12),
                Text(
                  'İçerik:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    msg.modelIcerik,
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
              child: Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMessages = paginatedMessages;

    return Column(
      children: [
        Expanded(
          child:
              currentMessages.isEmpty
                  ? Container(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.message_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Henüz mesaj bulunmuyor',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Yukarıdaki formu kullanarak mesaj gönderebilirsiniz.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.separated(
                    itemCount: currentMessages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final msg = currentMessages[index];
                      final isSentMessage =
                          msg.modelGondericiTur ==
                          1; // Assuming 1 is for sent messages
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.grey.withOpacity(0.3),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () => _showDetailDialog(context, msg),
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                    isSentMessage
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isSentMessage
                                          ? Colors.green.withOpacity(0.3)
                                          : Colors.blue.withOpacity(0.3),
                                ),
                              ),
                              child: Icon(
                                isSentMessage
                                    ? Icons.arrow_forward
                                    : Icons.arrow_back,
                                color:
                                    isSentMessage ? Colors.green : Colors.blue,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              isSentMessage
                                  ? 'Gönderilen: ${msg.modelKimeAdSoyad}'
                                  : 'Gönderen: ${msg.modelKimdenAdSoyad}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isSentMessage
                                      ? 'Alıcı: ${msg.modelKimeAdSoyad}'
                                      : 'Alıcı: ${msg.modelKimeAdSoyad}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  msg.modelTarih,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.visibility,
                              color: Colors.deepPurple.withOpacity(0.6),
                              size: 20,
                            ),
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
              onPressed: currentPage > 0 ? _goToPrevious : null,
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
              'Sayfa ${totalPages == 0 ? 0 : currentPage + 1} / $totalPages',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: (currentPage + 1) < totalPages ? _goToNext : null,
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
