import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';

class EtkinlikKart extends StatelessWidget {
  final int? id;
  final String isim;
  final String ucret;
  final DateTime tarih;
  final TimeOfDay saat;
  final File? dosya;
  final String? aciklama;
  final String? resimBinary; // Base64 string olarak gelen resim
  final String resim;

  final bool isWeb;
  final int index;
  final VoidCallback? onDelete;
  final Function(Map<String, dynamic>)? onUpdate;

  const EtkinlikKart({
    super.key,
    this.id,
    required this.isim,
    required this.ucret,
    required this.tarih,
    required this.saat,
    required this.dosya,
    this.aciklama,
    this.resimBinary,
    required this.resim,
    required this.isWeb,
    required this.index,
    this.onDelete,
    this.onUpdate,
  });

 Widget _buildImageWidget() {
    if (resim.isNotEmpty) {
      // Eğer resim bir URL ise (http ile başlıyorsa) NetworkImage kullan
      if (resim.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            resim,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Resim url hatası: $error');
              return const Icon(Icons.error, size: 50, color: Colors.red);
            },
          ),
        );
      } else {
        // Dosya yolu ise
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(resim),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Resim dosya hatası: $error');
              return const Icon(Icons.error, size: 50, color: Colors.red);
            },
          ),
        );
      }
    } else if (dosya != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          dosya!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Dosya resmi hatası: $error');
            return const Icon(Icons.error, size: 50, color: Colors.red);
          },
        ),
      );
    } else {
      return const Icon(Icons.image, size: 50, color: Colors.grey);
    }
  }
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Silme Onayı'),
          content: const Text('Bu etkinliği silmek istediğinize emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onDelete != null) {
                  onDelete!();
                }
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void _showDetailDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: isim,
    );
    final TextEditingController feeController = TextEditingController(
      text: ucret,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: aciklama ?? '',
    );

    DateTime selectedDate = tarih;
    TimeOfDay selectedTime = saat;
    bool hasChanges = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool checkForChanges() {
              return nameController.text != isim ||
                  feeController.text != ucret ||
                  descriptionController.text != (aciklama ?? '') ||
                  selectedDate != tarih ||
                  selectedTime != saat;
            }

            nameController.addListener(() {
              setState(() {
                hasChanges = checkForChanges();
              });
            });
            feeController.addListener(() {
              setState(() {
                hasChanges = checkForChanges();
              });
            });
            descriptionController.addListener(() {
              setState(() {
                hasChanges = checkForChanges();
              });
            });

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.edit, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Text(
                    'Etkinlik Düzenle',
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
                    if (id != null) _buildDetailRow('ID:', id.toString()),
                    SizedBox(height: 8),
                    Text(
                      'İsim:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tarih:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                            hasChanges = checkForChanges();
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Saat:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (picked != null && picked != selectedTime) {
                          setState(() {
                            selectedTime = picked;
                            hasChanges = checkForChanges();
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          selectedTime.format(context),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Ücret:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    TextField(
                      controller: feeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Açıklama:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('İptal'),
                ),
                ElevatedButton(
                  onPressed:
                      hasChanges
                          ? () {
                            Navigator.of(context).pop();
                            if (onUpdate != null) {
                              onUpdate!({
                                'ad': nameController.text,
                                'tutar': feeController.text,
                                'tarih':
                                    selectedDate.toIso8601String().split(
                                      'T',
                                    )[0],
                                'saat':
                                    '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                                'aciklama': descriptionController.text,
                              });
                            }
                          }
                          : null,
                  child: Text('Güncelle'),
                ),
              ],
            );
          },
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
    print('EtkinlikKart render: $isim'); // Hata ayıklama
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: isWeb ? 6 : 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          InkWell(
            onTap: () => _showDetailDialog(context),
            borderRadius: BorderRadius.circular(12),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: isWeb ? 20 : 16,
                vertical: isWeb ? 12 : 8,
              ),
              leading: Stack(
                children: [
                  _buildImageWidget(),
                  if (aciklama != null && aciklama!.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.info, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
              title: Text(
                isim,
                style: TextStyle(
                  fontSize: isWeb ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tarih: ${tarih.day}/${tarih.month}/${tarih.year}',
                    style: TextStyle(
                      fontSize: isWeb ? 14 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Saat: ${saat.format(context)}',
                    style: TextStyle(
                      fontSize: isWeb ? 14 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Ücret: $ucret TL',
                    style: TextStyle(
                      fontSize: isWeb ? 14 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.edit,
                color: Colors.deepPurple.withOpacity(0.6),
                size: 20,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: () => _showDeleteConfirmation(context),
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Icon(Icons.delete, size: 18, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
