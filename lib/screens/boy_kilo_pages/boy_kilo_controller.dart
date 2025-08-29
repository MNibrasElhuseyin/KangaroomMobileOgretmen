import 'package:kangaroom_mobile/services/api_service.dart';

import 'package:kangaroom_mobile/models/boyKilo/get_ogrenci_list.dart';
import 'package:kangaroom_mobile/models/boyKilo/get_boy_kilo.dart';
import 'package:kangaroom_mobile/models/boyKilo/post_boy_kilo.dart';

class BoyKiloController {
  List<GetOgrenciListModel> ogrenciListesi = [];
  List<BoyKiloModel> boyKiloListesi = [];

  bool isLoadingOgrenciler = false;
  bool isLoadingBoyKilo = false;

  /// Öğrenci listesi
  Future<void> fetchOgrenciList() async {
    isLoadingOgrenciler = true;
    try {
      ogrenciListesi = await ApiService.getList<GetOgrenciListModel>(
        'BoyKilo/OgrenciListesi',
        (j) => GetOgrenciListModel.fromJson(j),
      );
    } catch (e) {
      ogrenciListesi = [];
      throw Exception('📶 İnternet bağlantınızı kontrol ediniz');
    } finally {
      isLoadingOgrenciler = false;
    }
  }

  /// Boy-Kilo kayıtları
  Future<void> fetchBoyKiloList() async {
    isLoadingBoyKilo = true;
    try {
      boyKiloListesi = await ApiService.getList<BoyKiloModel>(
        'BoyKilo',
        (j) => BoyKiloModel.fromJson(j),
      );
    } catch (e) {
      boyKiloListesi = [];
      throw Exception('📶 İnternet bağlantınızı kontrol ediniz');
    } finally {
      isLoadingBoyKilo = false;
    }
  }

  /// Yeni kayıt
  Future<bool> saveRecord(PostBoyKiloModel m) async {
    final body = <String, dynamic>{
      'ogrenciId': m.ogrenciId,
      'boy': m.boy,
      'kilo': m.kilo,
      'aciklama':
          (m.aciklama.trim().isEmpty)
              ? 'Normal gelişim'
              : m.aciklama.trim(),
      'tarih': m.tarih, // YYYY-MM-DD
    };
    return ApiService.post('BoyKilo', body, wrapInList: false);
  }

  /// Güncelleme – delta ile uğraşmadan her zaman tam veri gönder
  Future<bool> updateRecordFull({
    required int id,
    required double boy,
    required double kilo,
    required String aciklama,
    String? tarih, // backend destekliyorsa
    int? okulId, // backend destekliyorsa
  }) async {
    final body = <String, dynamic>{
      'Id': id,
      'boy': boy,
      'kilo': kilo,
      'aciklama': aciklama.trim().isEmpty ? 'Normal gelişim' : aciklama.trim(),
      if (tarih != null) 'tarih': tarih,
      if (okulId != null) 'okulId': okulId,
      // personel_id ApiService.post tarafından eklenir
    };
    return ApiService.post('BoyKilo', body, wrapInList: false);
  }

  /// Silme
  Future<bool> deleteRecord(int id) async {
    // ApiService.delete body’ye personel_id ekler; backend kabul ediyor
    return ApiService.delete('BoyKilo', {'id': id}, wrapInList: false);
  }
}
