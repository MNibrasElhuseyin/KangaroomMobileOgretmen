import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/ogrenciTakip/get_ogrenci_list.dart';
import 'package:kangaroom_mobile/models/ogrenciTakip/get_ogrenci_takip.dart';
import 'package:kangaroom_mobile/models/ogrenciTakip/post_ogrenci_yoklama.dart';
import 'package:kangaroom_mobile/models/ogrenciTakip/post_ogrenci_uyku.dart';
import 'package:kangaroom_mobile/models/ogrenciTakip/post_ogrenci_duygu_durum.dart';
import 'package:kangaroom_mobile/models/ogrenciTakip/post_ogrenci_beslenme.dart';
import 'package:kangaroom_mobile/services/api_service.dart';

class OgrenciTakipController extends ChangeNotifier {
  final ValueNotifier<bool> isLoadingOgrenciList = ValueNotifier(false);
  final ValueNotifier<String?> errorOgrenciList = ValueNotifier(null);
  final ValueNotifier<List<GetOgrenciListModel>> _ogrenciList = ValueNotifier(
    [],
  );

  // Getter for ogrenci list
  List<GetOgrenciListModel> get ogrenciList => _ogrenciList.value;

  // Takip verileri için
  final ValueNotifier<List<GetOgrenciModel>> takipList = ValueNotifier([]);
  final ValueNotifier<bool> isLoadingTakip = ValueNotifier(false);
  final ValueNotifier<String?> errorTakip = ValueNotifier(null);

  /// Öğrenci listesini API’den çek
  Future<void> fetchOgrenciList() async {
    isLoadingOgrenciList.value = true;
    errorOgrenciList.value = null;
    notifyListeners();

    try {
      final List<GetOgrenciListModel> fetchedList =
          await ApiService.getList<GetOgrenciListModel>(
            'OgrenciTakip/OgrenciListesi',
            (json) => GetOgrenciListModel.fromJson(json),
          );
      _ogrenciList.value = fetchedList;
    } catch (e) {
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      String cleanMessage;
      if (message.contains('Exception: ')) {
        cleanMessage = message.replaceFirst('Exception: ', '');
      } else {
        cleanMessage = message;
      }
      errorOgrenciList.value = cleanMessage;
      _ogrenciList.value = [];
    } finally {
      isLoadingOgrenciList.value = false;
      notifyListeners();
    }
  }

  /// Seçilen öğrenciye ait takip verilerini getir
  Future<void> fetchTakipByOgrenciId(int ogrenciId, String date) async {
    isLoadingTakip.value = true;
    errorTakip.value = null;
    notifyListeners();

    try {
      final data = await ApiService.getList<GetOgrenciModel>(
        'OgrenciTakip',
        (json) {
          try {
            // Raw JSON'u görmek için log ekle
            print('🔍 Raw JSON: $json');
            return GetOgrenciModel.fromJson(json);
          } catch (parseError) {
            print('JSON Parse Hatası: $parseError');
            print('Problematik JSON: $json');
            rethrow;
          }
        },
        queryParams: {'ogrenci_id': ogrenciId.toString(), 'date': date},
      );
      takipList.value = data;

      // Debug için API response'u yazdır
      print('Takip API Response: $data');
      if (data.isNotEmpty) {
        print('İlk öğe: ${data.first}');
      }
    } catch (e) {
      takipList.value = [];
      final message = e.toString();
      // Kullanıcıya daha anlaşılır hata mesajı göster
      String cleanMessage;
      if (message.contains('Exception: ')) {
        cleanMessage = message.replaceFirst('Exception: ', '');
      } else {
        cleanMessage = message;
      }
      errorTakip.value = cleanMessage;

      // Debug için hatayı da yazdır
      print('Takip API Hatası: $e');
    } finally {
      isLoadingTakip.value = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isLoadingOgrenciList.dispose();
    errorOgrenciList.dispose();
    _ogrenciList.dispose();
    takipList.dispose();
    isLoadingTakip.dispose();
    errorTakip.dispose();
    super.dispose();
  }

 

  // Yeni: Öğrenci yoklama verisini POST etmek için method
  Future<bool> postOgrenciYoklamaBatch(
    List<PostOgrenciYoklamaModel> postModels,
  ) async {
    try {
      final jsonList = postModels.map((e) => e.toJson()).toList();

      final result = await ApiService.post('OgrenciTakip/Yoklama', jsonList);

      if (result) {
        print('✅ Toplu yoklama kaydı başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Toplu yoklama post hatası: $e');
      return false;
    }
  }
   // Yeni: Öğrenci Uyku verisini POST etmek için method
  Future<bool> postOgrenciUykuBatch(
    List<PostOgrenciUykuModel> postModels,
  ) async {
    try {
      final jsonList = postModels.map((e) => e.toJson()).toList();

      final result = await ApiService.post('OgrenciTakip/Uyku', jsonList);

      if (result) {
        print('✅ Toplu uyku kaydı başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Toplu uyku post hatası: $e');
      return false;
    }
  }
    // Yeni: Öğrenci Duygu verisini POST etmek için method
  Future<bool> postOgrenciDuyguBatch(
    List<PostOgrenciDuyguDurumModel> postModels,
  ) async {
    try {
      final jsonList = postModels.map((e) => e.toJson()).toList();

      final result = await ApiService.post('OgrenciTakip/DuyguDurum', jsonList);

      if (result) {
        print('✅ Toplu duygu kaydı başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Toplu duygu post hatası: $e');
      return false;
    }
  }
      // Yeni: Öğrenci Beslenme verisini POST etmek için method
  Future<bool> postOgrenciBeslenmeBatch(
    List<PostOgrenciBeslenmeModel> postModels,
  ) async {
    try {
      final jsonList = postModels.map((e) => e.toJson()).toList();

      final result = await ApiService.post('OgrenciTakip/Beslenme', jsonList);

      if (result) {
        print('✅ Toplu beslenme kaydı başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Toplu beslenme post hatası: $e');
      return false;
    }
  }
}
