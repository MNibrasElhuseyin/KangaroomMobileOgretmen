import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/get_ders_list.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/get_ogrenci_list_all.dart';
import 'package:kangaroom_mobile/services/api_service.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/post_ders_resim_video.dart';
import 'ders_resimleri_controller.dart';
import 'ders_ekle_dialog.dart';

class DersResimleriView extends StatefulWidget {
  const DersResimleriView({super.key});

  @override
  State<DersResimleriView> createState() => _DersResimleriViewState();
}

class _DersResimleriViewState extends State<DersResimleriView> {
  final DersResimleriController controller = DersResimleriController();
  List<GetDersListModel> dersListesi = [];
  List<GetOgrenciListAllModel> ogrenciListesi = [];
  bool isLoadingDersler = false;
  bool isLoadingOgrenciler = false;

  @override
  void initState() {
    super.initState();
    // Burada ders ve öğrenci yükleme fonksiyonlarını çağırabilirsin
    // _loadDersler();
    // _loadOgrenciler();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: "Öğrenci"),
            value: controller.selectedOgrenci,
            items:
                ogrenciListesi
                    .map(
                      (ogrenci) => DropdownMenuItem(
                        value: ogrenci.modelID,
                        child: Text(ogrenci.modelAdSoyad),
                      ),
                    )
                    .toList(),
            onChanged:
                isLoadingOgrenciler
                    ? null
                    : (value) =>
                        setState(() => controller.selectedOgrenci = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.aciklamaController,
            decoration: const InputDecoration(labelText: "Açıklama"),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                type: FileType.custom,
                allowedExtensions: [
                  'jpg',
                  'jpeg',
                  'png',
                  'gif',
                  'bmp',
                  'webp',
                  'mp4',
                  'mov',
                  'avi',
                  'wmv',
                  'flv',
                  'webm',
                  'mkv',
                  '3gp',
                ],
              );
              if (result != null && result.files.isNotEmpty) {
                setState(() {
                  controller.selectedFiles =
                      result.files
                          .where((f) => f.path != null)
                          .map((f) => File(f.path!))
                          .toList();
                });
              }
            },
            icon: const Icon(Icons.upload_file),
            label: Text(
              controller.selectedFiles.isEmpty
                  ? "Dosya Seç"
                  : "${controller.selectedFiles.length} dosya seçildi",
            ),
          ),
          const SizedBox(height: 16),
           if (controller.selectedFiles.isNotEmpty)
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   "Seçilen Dosyalar:",
                   style: TextStyle(fontWeight: FontWeight.bold),
                 ),
                 ...controller.selectedFiles.map(
                   (f) => Text(f.path.split(Platform.pathSeparator).last),
                 ),
                 const SizedBox(height: 8),
               ],
             ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (controller.selectedDers == null ||
                  controller.selectedFiles.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lütfen ders seçin ve dosya(lar) yükleyin.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final selectedDersId =
                  dersListesi
                      .firstWhere(
                        (ders) => ders.modelAd == controller.selectedDers,
                        orElse: () => dersListesi.first,
                      )
                      .modelID;

              // PostDersResimVideoModel listesi oluşturulmalı
              final postModels = [
                PostDersResimVideoModel(
                  dersId: selectedDersId,
                  ogrenciId: controller.selectedOgrenci ?? -1,
                  files: controller.selectedFiles.map((f) => f.path).toList(),
                ),
              ];

              final success = await controller.postDersResimleriBatch(
                postModels,
              );

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dosya(lar) başarıyla yüklendi!'),
                    backgroundColor: Colors.green,
                  ),
                );
                controller.resetForm();
                setState(() {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dosya(lar) yüklenirken hata oluştu.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }
}
