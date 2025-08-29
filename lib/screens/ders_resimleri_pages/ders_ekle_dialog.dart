import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/post_ders_list.dart';
import 'package:kangaroom_mobile/services/api_service.dart';
import 'ders_resimleri_controller.dart';
import 'package:kangaroom_mobile/config/global_config.dart';

class DersEkleDialog extends StatefulWidget {
  final DersResimleriController controller;
  final VoidCallback onDersAdded;

  const DersEkleDialog({
    super.key,
    required this.controller,
    required this.onDersAdded,
  });

  @override
  State<DersEkleDialog> createState() => _DersEkleDialogState();
}

class _DersEkleDialogState extends State<DersEkleDialog> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;
    final dialogWidth = isLargeScreen ? screenWidth * 0.5 : screenWidth * 0.9;
    final fontScale = isLargeScreen ? 1.2 : 1.0;

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
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: widget.controller.dersAdiController,
                decoration: InputDecoration(
                  labelText: "Ders Adı *",
                  labelStyle: TextStyle(fontSize: 14 * fontScale),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 14 * fontScale),
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: isLargeScreen ? 16 : 12),
              TextField(
                controller: widget.controller.aciklamaController,
                decoration: InputDecoration(
                  labelText: "Açıklama",
                  labelStyle: TextStyle(fontSize: 14 * fontScale),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 14 * fontScale),
              ),
              SizedBox(height: isLargeScreen ? 16 : 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  return ElevatedButton.icon(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();
                      if (result != null) {
                        setState(() {
                          widget.controller.selectedFile = File(result.files.first.path!);
                        });
                      }
                    },
                    icon: Icon(Icons.upload_file, size: 18 * fontScale),
                    label: Text(
                      widget.controller.selectedFile?.path.split('/').last ?? "Dosya Seç",
                      style: TextStyle(fontSize: 12 * fontScale),
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isLargeScreen ? 14 : 12,
                        horizontal: isLargeScreen ? 16 : 12,
                      ),
                      minimumSize: Size(constraints.maxWidth, isLargeScreen ? 48 : 40),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "İptal",
            style: TextStyle(fontSize: 14 * fontScale),
          ),
        ),
        ElevatedButton(
          onPressed: widget.controller.isFormValid()
              ? () async {
            final postDers = PostDersListModel(
              ad: widget.controller.dersAdiController.text.trim(),
              personelId: GlobalConfig.personelID,
              aciklama: widget.controller.aciklamaController.text.trim().isNotEmpty
                  ? widget.controller.aciklamaController.text.trim()
                  : null,
            );

            final success = await ApiService.post(
              'DersResimVideo/DersListesi',
              postDers.toJson(),
              wrapInList: false,
            );

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ders başarıyla eklendi!'),
                  backgroundColor: Colors.green,
                ),
              );
              widget.controller.resetForm();
              widget.onDersAdded();
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ders eklenirken hata oluştu.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
              : null,
          child: Text(
            "Kaydet",
            style: TextStyle(fontSize: 14 * fontScale),
          ),
        ),
      ],
    );
  }
}