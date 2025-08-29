import 'package:flutter/material.dart';
import '../../models/etkinlikOnay/get_etkinlik_list.dart';
import '../../models/etkinlikOnay/get_etkinlik_onay.dart';
import '../../../services/api_service.dart';

class EtkinlikOnayController extends ChangeNotifier {
  List<String> etkinlikListesi = [];
  List<String> durumListesi = ["İzin Verildi", "İzin Verilmedi"];

  String? seciliEtkinlik;
  String? seciliDurum;

  List<GetEtkinlikOnay> tumOnayListesi = [];

  /// Yeni metot: önce etkinlik listesini getirir, başarılıysa onay listesini getirir.
  /// Başarısızlıkta ikinci isteği yapmaz.
  Future<void> fetchTumVeriler() async {
    try {
      await fetchEtkinlikListesi();

      // Eğer etkinlik listesi boşsa veya boş liste geldiyse ikinci isteği yapma
      if (etkinlikListesi.isEmpty) {
        // İstersen burada notifyListeners() sonrası UI hata gösterebilir.
        return;
      }

      await fetchEtkinlikOnayListesi();
    } catch (e) {
      // Burada da istersen loglama yapılabilir
      etkinlikListesi = [];
      tumOnayListesi = [];
      throw Exception('📶 İnternet bağlantınızı kontrol ediniz');
    }
  }

  Future<void> fetchEtkinlikListesi() async {
    try {
      final data = await ApiService.getList<GetEtkinlikListModel>(
        "EtkinlikOnay/EtkinlikListesi",
        (json) => GetEtkinlikListModel.fromJson(json),
      );
      etkinlikListesi = data.map((e) => e.ad).toList();
    } catch (e) {
      etkinlikListesi = [];
      throw Exception('📶 İnternet bağlantınızı kontrol ediniz');
    }
    notifyListeners();
  }

  Future<void> fetchEtkinlikOnayListesi() async {
    try {
      tumOnayListesi = await ApiService.getList<GetEtkinlikOnay>(
        "EtkinlikOnay",
        (json) => GetEtkinlikOnay.fromJson(json),
      );
    } catch (e) {
      tumOnayListesi = [];
      throw Exception('📶 İnternet bağlantınızı kontrol ediniz');
    }
    notifyListeners();
  }

  List<GetEtkinlikOnay> filtrele() {
    return tumOnayListesi.where((item) {
      final bool etkinlikUygun =
          seciliEtkinlik == null ||
          seciliEtkinlik == "" ||
          item.etkinlikAd == seciliEtkinlik;
      final bool durumUygun =
          seciliDurum == null || item.durum == seciliDurum;
      return etkinlikUygun && durumUygun;
    }).toList();
  }
}