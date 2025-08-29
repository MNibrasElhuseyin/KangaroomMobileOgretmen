class GetOgrenciModel {
  final Map<String, Map<String, dynamic>> yemekMap;
  final Map<String, dynamic> duygu;
  final Map<String, dynamic> yoklama;
  final List<Map<String, dynamic>> uyku;

  GetOgrenciModel({
    required this.yemekMap,
    required this.duygu,
    required this.yoklama,
    required this.uyku,
  });

  factory GetOgrenciModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> mealMap = json['meal'] ?? {};
    Map<String, Map<String, dynamic>> yemekMap = {};

    // Yemek map'ini güvenli şekilde oluştur
    mealMap.forEach((key, value) {
      if (value != null && value is Map<String, dynamic>) {
        yemekMap[key] = {"durum": value['durum'], "id": value['id']};
      } else {
        yemekMap[key] = {"durum": null, "id": null};
      }
    });

    // Safely access nested objects with null checks
    Map<String, dynamic>? emotionData = json['emotion'];
    Map<String, dynamic>? attendanceData = json['attendance'];

    return GetOgrenciModel(
      yemekMap: yemekMap,
      duygu: {"durum": emotionData?['durum'], "id": emotionData?['id']},
      yoklama: {"durum": attendanceData?['durum'], "id": attendanceData?['YoklamaID']},
      uyku: List<Map<String, dynamic>>.from(json['sleep'] ?? []),
    );
  }

  // 🎯 UI-friendly accessors below

  // Yoklama
  int? get modelYoklamaDurum {
    final durum = yoklama['durum'];
    if (durum is bool) return durum ? 1 : 0;
    return durum as int?;
  }

  int? get modelYoklamaID => yoklama['id'] as int?;

  // Duygu
  int? get modelDuyguDurum {
    final durum = duygu['durum'];
    if (durum is bool) return durum ? 1 : 0;
    return durum as int?;
  }

  int? get modelDuyguID => duygu['id'] as int?;

  // Uyku
  List<Map<String, dynamic>> get modelUykuListesi => uyku;

  // Yemek
  Map<String, Map<String, dynamic>> get modelYemekMap => yemekMap;

  // 🍽 Yemek açıklama çevirici
  String modelYemekDurumToText(int? durum) {
    switch (durum) {
      case 0:
        return 'Hiç Yemedi';
      case 1:
        return 'Çeyrek Porsiyon';
      case 2:
        return 'Yarım Porsiyon';
      case 3:
        return 'Tam Porsiyon';
      default:
        return 'Bilinmiyor';
    }
  }

  // 😊 Duygu açıklama çevirici
  String get modelDuyguText {
    switch (modelDuyguDurum) {
      case 0:
        return 'Kızgın';
      case 1:
        return 'Üzgün';
      case 2:
        return 'Mutsuz';
      case 3:
        return 'Normal';
      case 4:
        return 'Mutlu';
      default:
        return 'Bilinmiyor';
    }
  }

  // 💤 Uyku açıklama çevirici (tek bir item için)
  String modelUykuText(int? uykuDurum) {
    switch (uykuDurum) {
      case 0:
        return 'Uyumadı';
      case 1:
        return 'Dinlendi';
      case 2:
        return 'Uyudu';
      default:
        return 'Bilinmiyor';
    }
  }

  // 📋 Yoklama metni
  String get modelYoklamaText {
    final durum = modelYoklamaDurum;
    if (durum == null) return 'Bilinmiyor';
    return durum == 1 ? 'Geldi' : 'Gelmedi';
  }
}
