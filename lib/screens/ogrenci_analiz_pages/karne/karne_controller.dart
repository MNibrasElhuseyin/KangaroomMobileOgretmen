import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/karne/get_gelisim_list.dart';
import 'package:kangaroom_mobile/models/karne/get_gelisim_tur_list.dart';
import 'package:kangaroom_mobile/models/karne/get_karne.dart';
import 'package:kangaroom_mobile/services/api_service.dart';

class KarneController {
  // Genel loading ve hata (fetchAll için)
  final ValueNotifier<bool> isLoadingAll = ValueNotifier(false);
  final ValueNotifier<String?> errorAll = ValueNotifier(null);

  // Loading ve hata için notifierlar
  final ValueNotifier<bool> isLoadingGelisimList = ValueNotifier(false);
  final ValueNotifier<String?> errorGelisimList = ValueNotifier(null);
  final ValueNotifier<List<GetGelisimListModel>> gelisimList = ValueNotifier([]);

  // tur'a göre gruplanmış hali
  final ValueNotifier<Map<int, List<GetGelisimListModel>>> gelisimListMap = ValueNotifier({});

  final ValueNotifier<bool> isLoadingGelisimTurList = ValueNotifier(false);
  final ValueNotifier<String?> errorGelisimTurList = ValueNotifier(null);
  final ValueNotifier<List<GetGelisimTurListModel>> gelisimTurList = ValueNotifier([]);

  final ValueNotifier<bool> isLoadingOgrenciList = ValueNotifier(false);
  final ValueNotifier<String?> errorOgrenciList = ValueNotifier(null);

  // Yeni: Karne verileri için
  final ValueNotifier<List<GetKarne>> karneList = ValueNotifier([]);
  final ValueNotifier<bool> isLoadingKarneList = ValueNotifier(false);
  final ValueNotifier<String?> errorKarneList = ValueNotifier(null);

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
      errorGelisimList.value = e.toString();
      throw e;
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
      errorGelisimTurList.value = e.toString();
      throw e;
    } finally {
      isLoadingGelisimTurList.value = false;
    }
  }

  /// Hepsini tek seferde çekmek için yardımcı method
  Future<void> fetchAll() async {
    isLoadingAll.value = true;
    errorAll.value = null;
    try {
      await Future.wait([
        fetchGelisimList(),
        fetchGelisimTurList(),
      ]);
    } catch (e) {
      errorAll.value = e.toString();
    } finally {
      isLoadingAll.value = false;
    }
  }

  /// Yeni: Seçilen öğrenciye ait karne puanlarını getir
  Future<void> fetchKarneByOgrenciId(int ogrenciId) async {
    isLoadingKarneList.value = true;
    errorKarneList.value = null;
    try {
      final data = await ApiService.getList<GetKarne>(
        'Karne',
        (json) => GetKarne.fromJson(json),
        queryParams: {'ogrenci_id': ogrenciId.toString()},
      );
      karneList.value = data;
    } catch (e) {
      karneList.value = [];
      errorKarneList.value = e.toString();
    } finally {
      isLoadingKarneList.value = false;
    }
  }
}
