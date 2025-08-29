import 'package:flutter/material.dart';
import 'sinif_takip_controller.dart';

class GenelKayitButton extends StatelessWidget {
  final SinifTakipController controller;
  final int menuType; // 0: Yoklama, 1: Duygu Durum, 2: Uyku, 3: Beslenme, 4: İlaç, 5: Kıyafet
  final String? customLabel;
  final VoidCallback? onPressed;

  const GenelKayitButton({
    super.key,
    required this.controller,
    required this.menuType,
    this.customLabel,
    this.onPressed,
  });

  String get _defaultLabel {
    switch (menuType) {
      case 0:
        return 'Yoklama Al';
      case 1:
        return 'Duygu Kaydet';
      case 2:
        return 'Uyku Kaydet';
      case 3:
        return 'Beslenme Kaydet';
      case 4:
        return 'İlaç Kaydet';
      case 5:
        return 'Kıyafet Kaydet';
      default:
        return 'Kaydet';
    }
  }

  String get _successMessage {
    switch (menuType) {
      case 0:
        return 'Yoklama başarıyla kaydedildi.';
      case 1:
        return 'Duygu durum başarıyla kaydedildi.';
      case 2:
        return 'Uyku durumu başarıyla kaydedildi.';
      case 3:
        return 'Beslenme durumu başarıyla kaydedildi.';
      case 4:
        return 'İlaç durumu başarıyla kaydedildi.';
      case 5:
        return 'Kıyafet durumu başarıyla kaydedildi.';
      default:
        return 'Veriler başarıyla kaydedildi.';
    }
  }

  String get _errorMessage {
    switch (menuType) {
      case 0:
        return 'Yoklama kaydedilirken hata oluştu.';
      case 1:
        return 'Duygu durum kaydedilirken hata oluştu.';
      case 2:
        return 'Uyku durumu kaydedilirken hata oluştu.';
      case 3:
        return 'Beslenme durumu kaydedilirken hata oluştu.';
      case 4:
        return 'İlaç durumu kaydedilirken hata oluştu.';
      case 5:
        return 'Kıyafet kaydedilirken hata oluştu.';
      default:
        return 'Kayıt sırasında hata oluştu.';
    }
  }

  bool get _hasChanges {
    switch (menuType) {
      case 0:
        return controller.hasYoklamaChanges();
      case 1:
        return controller.hasDuyguDurumChanges();
      case 2:
        return controller.hasUykuChanges();
      case 3:
        return controller.hasBeslenmeChanges();
      case 4:
        return controller.hasIlacChanges();
      case 5:
        return controller.hasKiyafetChanges();
      default:
        return false;
    }
  }

  Future<bool> _saveChanges() async {
    switch (menuType) {
      case 0:
        return await controller.postYoklamaDegisiklikleri();
      case 1:
        return await controller.postDuyguDurumDegisiklikleri();
      case 2:
        return await controller.postUykuDegisiklikleri();
      case 3:
        return await controller.postBeslenmeDegisiklikleri();
      case 4:
        return await controller.postIlacDegisiklikleri();
      case 5:
        return await controller.postKiyafetDegisiklikleri();
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasChanges = _hasChanges;
    final isLoading = controller.isLoading;

    return ElevatedButton(
      onPressed: hasChanges && !isLoading
          ? () async {
        try {
          final success = await _saveChanges();

          if (!context.mounted) return;

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_successMessage),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }

          if (onPressed != null) {
            onPressed!();
          }
        } catch (e) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Beklenmeyen hata: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: hasChanges && !isLoading
            ? Colors.deepPurple
            : Colors.grey[400],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      child: isLoading
          ? const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
          : Text(
        customLabel ?? _defaultLabel,
        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}