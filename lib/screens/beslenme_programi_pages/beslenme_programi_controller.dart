import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/beslenmeProgrami/get_beslenme_programi.dart';
import 'package:kangaroom_mobile/services/api_service.dart';

class BeslenmeProgramiController {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> error = ValueNotifier(null);
  final ValueNotifier<List<GetBeslenmeProgramiModel>> kayitlar = ValueNotifier([]);

  Future<void> fetchBeslenmeProgrami() async {
    isLoading.value = true;
    error.value = null;

    try {
      final data = await ApiService.getList<GetBeslenmeProgramiModel>(
        'BeslenmeProgrami',
        (json) => GetBeslenmeProgramiModel.fromJson(json),
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