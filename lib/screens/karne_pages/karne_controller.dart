import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/karne/get_gelisim_list.dart';
import 'package:kangaroom_mobile/models/karne/get_gelisim_tur_list.dart';
import 'package:kangaroom_mobile/models/karne/get_ogrenci_list.dart';
import 'package:kangaroom_mobile/models/karne/get_karne.dart';
import 'package:kangaroom_mobile/models/karne/post_karne.dart'; // EKLENDİ
import 'package:kangaroom_mobile/services/api_service.dart';

class KarneController {
  // Loading ve hata için notifierlar
  final ValueNotifier<bool> isLoadingGelisimList = ValueNotifier(false);
  final ValueNotifier<String?> errorGelisimList = ValueNotifier(null);
  final ValueNotifier<List<GetGelisimListModel>> gelisimList = ValueNotifier(
    [],
  );

  // tur'a göre gruplanmış hali
  final ValueNotifier<Map<int, List<GetGelisimListModel>>> gelisimListMap =
      ValueNotifier({});

  final ValueNotifier<bool> isLoadingGelisimTurList = ValueNotifier(false);
  final ValueNotifier<String?> errorGelisimTurList = ValueNotifier(null);
  final ValueNotifier<List<GetGelisimTurListModel>> gelisimTurList =
      ValueNotifier([]);

  final ValueNotifier<bool> isLoadingOgrenciList = ValueNotifier(false);
  final ValueNotifier<String?> errorOgrenciList = ValueNotifier(null);
  final ValueNotifier<List<GetOgrenciListModel>> ogrenciList = ValueNotifier(
    [],
  );

  // Yeni: Karne verileri için
  final ValueNotifier<List<GetKarne>> karneList = ValueNotifier([]);

  Future<void> fetchGelisimList() async {
    isLoadingGelisimList.value = true;
    errorGelisimList.value = null;
    try {
      final data = await ApiService.getList<GetGelisimListModel>(
        'Karne/GelisimListesi',
        (json) => GetGelisimListModel.fromJson(json),
      );
      gelisimList.value = data;

      // tur bazında grupla
      final Map<int, List<GetGelisimListModel>> grouped = {};
      for (var item in data) {
        grouped.putIfAbsent(item.tur, () => []).add(item);
      }
      gelisimListMap.value = grouped;
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      if (message.contains('Exception: ')) {
        errorGelisimList.value = message.replaceFirst('Exception: ', '');
      } else {
        errorGelisimList.value = message;
      }
    } finally {
      isLoadingGelisimList.value = false;
    }
  }

  Future<void> fetchGelisimTurList() async {
    isLoadingGelisimTurList.value = true;
    errorGelisimTurList.value = null;
    try {
      final data = await ApiService.getList<GetGelisimTurListModel>(
        'Karne/GelisimTurListesi',
        (json) => GetGelisimTurListModel.fromJson(json),
      );
      gelisimTurList.value = data;
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      if (message.contains('Exception: ')) {
        errorGelisimTurList.value = message.replaceFirst('Exception: ', '');
      } else {
        errorGelisimTurList.value = message;
      }
    } finally {
      isLoadingGelisimTurList.value = false;
    }
  }

  Future<void> fetchOgrenciList() async {
    isLoadingOgrenciList.value = true;
    errorOgrenciList.value = null;
    try {
      final data = await ApiService.getList<GetOgrenciListModel>(
        'Karne/OgrenciListesi',
        (json) => GetOgrenciListModel.fromJson(json),
      );
      ogrenciList.value = data;
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      if (message.contains('Exception: ')) {
        errorOgrenciList.value = message.replaceFirst('Exception: ', '');
      } else {
        errorOgrenciList.value = message;
      }
    } finally {
      isLoadingOgrenciList.value = false;
    }
  }

  /// Hepsini tek seferde çekmek için yardımcı method
  Future<void> fetchAll() async {
    await Future.wait([
      fetchGelisimList(),
      fetchGelisimTurList(),
      fetchOgrenciList(),
    ]);

    // Eğer bu 3 çağrıdan herhangi biri hata varsa hata fırlat
    if (errorGelisimList.value != null ||
        errorGelisimTurList.value != null ||
        errorOgrenciList.value != null) {
      throw Exception('📶 İnternet bağlantınızı kontrol ediniz');
    }
  }

  /// Yeni: Seçilen öğrenciye ait karne puanlarını getir
  Future<void> fetchKarneByOgrenciId(int ogrenciId) async {
    try {
      final data = await ApiService.getList<GetKarne>(
        'Karne',
        (json) => GetKarne.fromJson(json),
        queryParams: {'ogrenci_id': ogrenciId.toString()},
      );
      karneList.value = data;
    } catch (e) {
      karneList.value = [];
      // Hata yönetimi ekleyebilirsin
    }
  }

  /// Yeni: Karne verisini POST etmek için method
  Future<bool> postKarneBatch(List<PostKarne> postModels) async {
    try {
      final jsonList = postModels.map((e) => e.toJson()).toList();

      final result = await ApiService.post('Karne', jsonList);

      if (result) {
        print('✅ Toplu kayıt başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Toplu karne post hatası: $e');
      return false;
    }
  }
}
