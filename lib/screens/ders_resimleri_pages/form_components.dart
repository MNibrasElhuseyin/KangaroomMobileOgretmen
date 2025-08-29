import 'dart:io';
import 'package:flutter/material.dart';

class FormComponents {
  static Widget buildDersAdiSelector({
    required String? selectedDers,
    required List<String> dersListesi,
    required Function(String?) onDersChanged,
    required VoidCallback onYeniDersPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ders Adı",
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFFCF7FA),
                  border: Border.all(color: Colors.deepPurple.shade100),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedDers,
                    icon: Icon(Icons.arrow_drop_down, size: 20),
                    dropdownColor: Color(0xFFFCF7FA),
                    isExpanded: true,
                    style: TextStyle(color: Colors.deepPurple, fontSize: 14),
                    hint: Text(
                      "Ders seçiniz",
                      style: TextStyle(
                        color: Colors.deepPurple.withOpacity(0.6),
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: dersListesi.map((ders) {
                      return DropdownMenuItem<String>(
                        value: ders,
                        child: Text(
                          ders,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: onDersChanged,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: onYeniDersPressed,
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: const Text("Yeni", style: TextStyle(color: Colors.white, fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                minimumSize: Size(60, 40),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildOgrenciSelector({
    required int selectedOgrenci,
    required List<Map<String, dynamic>> ogrenciListesi,
    required bool isLoading,
    required Function(int?) onOgrenciChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Öğrenci",
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Color(0xFFFCF7FA),
            border: Border.all(color: Colors.deepPurple.shade100),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedOgrenci,
              icon: Icon(Icons.arrow_drop_down, size: 20),
              dropdownColor: Color(0xFFFCF7FA),
              isExpanded: true,
              style: TextStyle(color: Colors.deepPurple, fontSize: 14),
              items: ogrenciListesi.map((ogrenci) {
                return DropdownMenuItem<int>(
                  value: ogrenci['id'],
                  child: Text(
                    ogrenci['id'] == -1
                        ? ogrenci['ad']
                        : '${ogrenci['ad']} ${ogrenci['soyad']}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: isLoading ? null : onOgrenciChanged,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildAciklamaField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Açıklama",
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFFFCF7FA),
            border: Border.all(color: Colors.deepPurple.shade100),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: controller,
            maxLines: 2,
            style: TextStyle(color: Colors.deepPurple, fontSize: 14),
            decoration: InputDecoration(
              hintText: "Açıklama giriniz...",
              hintStyle: TextStyle(
                color: Colors.deepPurple.withOpacity(0.6),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildFilePreview({
    required File? selectedFile,
    required String? fileType,
    required VoidCallback onRemoveFile,
  }) {
    if (selectedFile == null) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                fileType == 'image' ? Icons.image : Icons.videocam,
                color: Colors.deepPurple,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Seçilen ${fileType == 'image' ? 'Resim' : 'Video'} Önizleme',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: onRemoveFile,
                icon: Icon(Icons.close, color: Colors.red, size: 20),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: fileType == 'image'
                  ? Image.file(
                selectedFile,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.grey[600], size: 40),
                        SizedBox(height: 8),
                        Text(
                          'Resim önizleme yüklenemedi',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                },
              )
                  : Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam, color: Colors.deepPurple, size: 50),
                    SizedBox(height: 8),
                    Text(
                      'Video Dosyası',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      selectedFile.path.split('/').last,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          FutureBuilder<int>(
            future: selectedFile.length(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final sizeInMB = snapshot.data! / (1024 * 1024);
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Dosya: ${selectedFile.path.split('/').last}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: sizeInMB < 50 ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sizeInMB < 50 ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${sizeInMB.toStringAsFixed(1)} MB',
                        style: TextStyle(
                          fontSize: 11,
                          color: sizeInMB < 50 ? Colors.green[700] : Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Text(
                'Dosya boyutu hesaplanıyor...',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget buildErrorMessage(String error) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}