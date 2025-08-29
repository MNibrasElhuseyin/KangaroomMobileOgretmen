import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadWidget extends StatefulWidget {
  const FileUploadWidget({super.key});

  @override
  State<FileUploadWidget> createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  String? fileName;
  String? filePath;
  final TextEditingController descriptionController = TextEditingController();

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      // Genişletilmiş dosya tipleri için FileType.custom kullanılıyor
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx', 'mp4', 'mov', 'avi'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        fileName = result.files.single.name;
        filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tema renklerini al
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color borderColor = primaryColor.withOpacity(0.4);

    return Card(
      elevation: 4, // Hafif bir gölge
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Daha yuvarlak köşeler
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Dış boşluk
      child: Padding(
        padding: const EdgeInsets.all(12.0), // İç boşluk
        child: IntrinsicHeight( // İçerik yüksekliğine göre ayarlanır
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Dikeyde tüm alanı kapla
            children: [
              // Dosya seçme alanı
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50], // Açık gri arka plan
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: OutlinedButton( // Arka planı transparan, çerçeveli buton
                    onPressed: pickFile,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero, // Padding'i manuel kontrol etmek için
                      side: BorderSide.none, // Kendi çerçevesi olmasın, container'ın çerçevesini kullansın
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0), // İç padding
                      child: Row(
                        children: [
                          Icon(Icons.folder_open, color: primaryColor, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              fileName ?? "Dosya Seç", // 'Dosya yok' yerine 'Dosya Seç'
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: primaryColor.withOpacity(0.8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12), // Alanlar arası boşluk arttırıldı

              // Açıklama kutusu
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50], // Açık gri arka plan
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0), // TextField için iç boşluk
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        border: InputBorder.none, // Çerçevesiz
                        hintText: "Açıklama ekle (isteğe bağlı)", // Daha açıklayıcı hintText
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        isDense: true, // Daha az dikey boşluk
                        contentPadding: EdgeInsets.zero, // Padding'i sıfırla, manuel kontrol
                      ),
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1, // Tek satırda kalması için
                      textAlignVertical: TextAlignVertical.center, // Ortalamak için
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Yükle butonu
              ElevatedButton.icon( // İkonlu buton
                onPressed: () {
                  if (filePath != null) {
                    print("Dosya: $filePath");
                    print("Açıklama: ${descriptionController.text}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Dosya ve açıklama hazır")),
                    );
                    // Yükleme sonrası inputları temizle
                    setState(() {
                      fileName = null;
                      filePath = null;
                      descriptionController.clear();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lütfen dosya seçin")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Temanın birincil rengi
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Yuvarlak köşeler
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                label: const Text("Yükle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}