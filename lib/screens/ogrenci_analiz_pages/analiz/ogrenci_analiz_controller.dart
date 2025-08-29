import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/ogrenciAnaliz/get_ogrenci_analiz.dart';
import 'package:kangaroom_mobile/services/api_service.dart';

class OgrenciAnalizController with ChangeNotifier {
  List<GetOgrenciAnaliz> ogrenciler = [];
  bool isLoading = false;
  String? errorMessage;

  GetOgrenciAnaliz? _secilenOgrenci;
  GetOgrenciAnaliz? get secilenOgrenci => _secilenOgrenci;

  Future<void> fetchOgrenciler() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      ogrenciler = await ApiService.getList<GetOgrenciAnaliz>(
        "OgrenciAnaliz",
        (json) => GetOgrenciAnaliz.fromJson(json),
      );
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  GetOgrenciAnaliz? getOgrenciByIndex(int index) {
    if (index < 0 || index >= ogrenciler.length) return null;
    return ogrenciler[index];
  }

  void setSecilenOgrenci(int index) {
    if (index < 0 || index >= ogrenciler.length) {
      _secilenOgrenci = null;
    } else {
      _secilenOgrenci = ogrenciler[index];
    }
    notifyListeners();
  }

  void clearSecilenOgrenci() {
    _secilenOgrenci = null;
    notifyListeners();
  }
}