class GetUykuModel {
  final int? id;
  final int ogrenciId;
  final String adSoyad;
  int durum; // Değiştirilebilir

  GetUykuModel({
    required this.id,
    required this.ogrenciId,
    required this.adSoyad,
    required this.durum,
  });

  factory GetUykuModel.fromJson(Map<String, dynamic> json) {
    return GetUykuModel(
      id: json['ID'] is int ? json['ID'] : int.tryParse(json['ID'].toString()),
      ogrenciId: json['OgrenciId'] is int ? json['OgrenciId'] : int.tryParse(json['OgrenciId'].toString()) ?? 0,
      adSoyad: json['OgrenciAdSoyad'] ?? '',
      durum: json['Durum'] is int ? json['Durum'] : int.tryParse(json['Durum'].toString()) ?? 0,
    );
  }

  // Kopyalama için yardımcı metod (immutable yaklaşım için)
  GetUykuModel copyWith({
    int? id,
    int? ogrenciId,
    String? adSoyad,
    int? durum,
  }) {
    return GetUykuModel(
      id: id ?? this.id,
      ogrenciId: ogrenciId ?? this.ogrenciId,
      adSoyad: adSoyad ?? this.adSoyad,
      durum: durum ?? this.durum,
    );
  }

  // UI
  int get modelID => id ?? 0;
  int get modelOgrenciId => ogrenciId;
  String get modelAdSoyad => adSoyad;
  String get modelDurum {
    switch (durum) {
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
}