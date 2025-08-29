import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_detay.dart';
import 'package:kangaroom_mobile/services/api_service.dart';

class OgrenciAnalizDetayController extends ChangeNotifier {
  GetOgrenciDetayModel? ogrenciDetay;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchOgrenciDetay(int ogrenciId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final liste = await ApiService.getList<GetOgrenciDetayModel>(
        'OgrenciAnaliz/Detay',
        (json) => GetOgrenciDetayModel.fromJson(json),
        queryParams: {'ogrenci_id': ogrenciId.toString()},
      );
      if (liste.isNotEmpty) {
        ogrenciDetay = liste.first;
      } else {
        errorMessage = 'Veri bulunamadı';
      }
    } catch (e) {
      errorMessage = 'Hata: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}