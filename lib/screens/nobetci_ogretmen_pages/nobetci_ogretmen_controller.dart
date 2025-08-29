import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/nobetciOgretmen/get_nobetci_ogretmen.dart';
import 'package:kangaroom_mobile/services/api_service.dart';

class NobetciOgretmenController {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);
  final ValueNotifier<List<GetNobetciOgretmenModel>> kayitlar = ValueNotifier([]);

  Future<void> fetchNobetciOgretmen() async {
    isLoading.value = true;
    error.value = null;

    try {
      final data = await ApiService.getList<GetNobetciOgretmenModel>(
        'NobetciOgretmen',
        (json) => GetNobetciOgretmenModel.fromJson(json),
      );
      kayitlar.value = data;
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      String cleanMessage;
      if (message.contains('Exception: ')) {
        cleanMessage = message.replaceFirst('Exception: ', '');
      } else {
        cleanMessage = message;
      }
      error.value = cleanMessage;
    } finally {
      isLoading.value = false;
    }
  }
}