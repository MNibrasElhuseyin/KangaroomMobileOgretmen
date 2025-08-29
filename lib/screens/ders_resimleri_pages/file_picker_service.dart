import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FilePickerService {
  List<File> selectedFiles = [];
  String? fileError;
  String? fileType; // image or video

  Future<bool?> _showFilePickerInfo(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.deepPurple, size: 28),
              SizedBox(width: 12),
              Text(
                'Dosya Yükleme Bilgileri',
                style: TextStyle(
                  color: Colors.deepPurple[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoCard(
                  icon: Icons.file_present,
                  title: 'Dosya Boyutu',
                  content: 'Maksimum 100 MB',
                  color: Colors.deepPurple,
                ),
                SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.image,
                  title: 'Resim Formatları',
                  content: 'JPG, JPEG, PNG, GIF, BMP, WEBP',
                  color: Colors.deepPurple,
                ),
                SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.videocam,
                  title: 'Video Formatları',
                  content: 'MP4, MOV, AVI, WMV, FLV, WEBM, MKV, 3GP',
                  color: Colors.deepPurple,
                ),
                SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.security,
                  title: 'Güvenlik',
                  content: 'Sadece resim ve video dosyaları kabul edilir',
                  color: Colors.deepPurple,
                ),
                SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.tips_and_updates,
                  title: 'Öneri',
                  content:
                      'En iyi kalite için PNG/JPG (resim) veya MP4 (video) formatını tercih edin',
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Dosya Seç'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickFiles(BuildContext context) async {
    bool? proceed = await _showFilePickerInfo(context);
    if (proceed != true) return;

    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        requestType: RequestType.common, // hem resim hem video
        maxAssets: 10, // istediğin gibi limit koyabilirsin
      ),
    );

    if (assets != null && assets.isNotEmpty) {
      selectedFiles = [];

      for (final asset in assets) {
        final File? f = await asset.file;
        if (f != null) {
          final fileSize = await f.length();
          const maxSizeInBytes = 100 * 1024 * 1024; // 100 MB

          if (fileSize > maxSizeInBytes) {
            fileError = 'Dosya boyutu 100 MB\'dan büyük olamaz: ${f.path}';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(fileError!),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
            continue;
          }

          selectedFiles.add(f);
        }
      }

      fileError = null;
    }
  }

  void clearFiles() {
    selectedFiles = [];
    fileError = null;
    fileType = null;
  }
}
