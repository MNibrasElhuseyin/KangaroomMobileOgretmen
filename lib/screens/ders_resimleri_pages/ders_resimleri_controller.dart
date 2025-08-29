import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/get_ders_list.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/get_ogrenci_list_all.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/post_ders_list.dart';
import 'package:kangaroom_mobile/models/dersResimVideo/post_ders_resim_video.dart';
import '/services/api_service.dart';
import 'package:http/http.dart' as http;
import '/config/global_config.dart';

class DersResimleriController {
  TextEditingController dersAdiController = TextEditingController();
  TextEditingController aciklamaController = TextEditingController();

  String? selectedDers;
  int? selectedOgrenci;
  List<File> selectedFiles = [];
  List<GetDersListModel> dersler = []; // EKLE

  List<GetOgrenciListAllModel> ogrenciler = [];
  bool isLoadingOgrenciler = false;
  String? error;

  void resetForm() {
    dersAdiController.clear();
    aciklamaController.clear();
    selectedDers = null;
    selectedOgrenci = null;
    selectedFiles = [];
  }

  bool isFormValid() {
    return dersAdiController.text.trim().isNotEmpty;
  }

  /// 📡 Öğrenci listesini API’den çek
  Future<void> fetchOgrenciler() async {
    isLoadingOgrenciler = true;
    error = null;

    try {
      final fetched = await ApiService.getList<GetOgrenciListAllModel>(
        "DersResimVideo/OgrenciListesi",
        (json) => GetOgrenciListAllModel.fromJson(json),
      );

      ogrenciler = [
        GetOgrenciListAllModel(id: -1, ad: "Tüm", soyad: "Sınıf"),
        ...fetched,
      ];
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingOgrenciler = false;
    }
  }

  File? get selectedFile =>
      selectedFiles.isNotEmpty ? selectedFiles.first : null;
  set selectedFile(File? file) {
    if (file != null) {
      selectedFiles = [file];
    } else {
      selectedFiles = [];
    }
  }

  Future<void> fetchDersData() async {
    try {
      dersler = await ApiService.getList<GetDersListModel>(
        'DersResimVideo/DersListesi',
        (json) => GetDersListModel.fromJson(json),
      );
    } catch (e) {
      dersler = [];
      debugPrint("Ders listesi API hatası: $e");
    }
  }

  // Yeni: Öğrenci ders resimleri verisini POST etmek için method
  Future<bool> postDersResimleriBatch(
    List<PostDersResimVideoModel> postModels,
  ) async {
    try {
      final model = postModels.first;
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://37.148.210.227:8000/DersResimVideo'),
      );
      request.fields['ders_id'] = model.dersId.toString();
      request.fields['ogrenci_id'] = model.ogrenciId.toString();
      // request.fields['personel_id'] = GlobalConfig.personelID.toString();

      // Çoklu dosya desteği (model.files kullanılmalı)
      for (var filePath in model.files) {
        request.files.add(await http.MultipartFile.fromPath('files', filePath));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        print('✅ Ders resmi/video kaydı başarılı');
        return true;
      } else {
        print(
          '❌ Ders resmi/video post hatası: [31m${response.statusCode}[0m',
        );
        return false;
      }
    } catch (e) {
      print('❌ Ders resmi/video post hatası: $e');
      return false;
    }
  }

  // Yeni: Öğrenci ders resimleri verisini POST etmek için method
  // ...existing code...
  Future<bool> postDersEkleBatch(List<PostDersListModel> postModels) async {
    try {
      final jsonObj = postModels.first.toJson(); // Sadece ilk modeli gönder
      print(jsonObj);
      final result = await ApiService.post(
        'DersResimVideo/DersListesi',
        jsonObj,
        wrapInList: false,
      );

      if (result) {
        print('✅ Ders ekleme kaydı başarılı');
      }

      return result;
    } catch (e) {
      print('❌ Ders ekleme post hatası: $e');
      return false;
    }
  }

  // ...existing code...
}
