import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/profil/get_profil.dart';
import '../../models/profil/post_profil.dart'; // hazır modeli import et

class ProfileController extends ChangeNotifier {
  bool isLoading = false;
  List<GetProfilModel> profilList = [];

  /// Profil verisini GET ile çek
  Future<void> fetchProfil() async {
    isLoading = true;
    notifyListeners();

    try {
      profilList = await ApiService.getList<GetProfilModel>(
        "Profil",
        (json) => GetProfilModel.fromJson(json),
      );
    } catch (e) {
      print('❌ Profil verisi alınamadı: $e');
      profilList = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Tek bir profili almak için
  GetProfilModel? get firstProfil {
    if (profilList.isNotEmpty) return profilList[0];
    return null;
  }

  /// POST ile profili güncelle
  Future<bool> updateProfil(PostProfilModel profil) async {
    try {
      final result = await ApiService.post(
        "Profil", // Backend endpoint
        profil.toJson(),
        wrapInList: false,
      );
      return result;
    } catch (e) {
      print('❌ Profil güncelleme hatası: $e');
      return false;
    }
  }
}