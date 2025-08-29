class GetDuyguDurumModel {
  final int? id;
  final int ogrenciId;
  final String adSoyad;
  int durum; // Değiştirilebilir

  GetDuyguDurumModel({
    required this.id,
    required this.ogrenciId,
    required this.adSoyad,
    required this.durum,
  });

  factory GetDuyguDurumModel.fromJson(Map<String, dynamic> json) {
    return GetDuyguDurumModel(
      id: json['ID'] is int ? json['ID'] : int.tryParse(json['ID'].toString()),
      ogrenciId: json['OgrenciId'] is int ? json['OgrenciId'] : int.tryParse(json['OgrenciId'].toString()) ?? 0,
      adSoyad: json['OgrenciAdSoyad'] ?? '',
      durum: json['Durum'] is int ? json['Durum'] : int.tryParse(json['Durum'].toString()) ?? 0,
    );
  }

  // Kopyalama için yardımcı metod (immutable yaklaşım için)
  GetDuyguDurumModel copyWith({
    int? id,
    int? ogrenciId,
    String? adSoyad,
    int? durum,
  }) {
    return GetDuyguDurumModel(
      id: id ?? this.id,
      ogrenciId: ogrenciId ?? this.ogrenciId,
      adSoyad: adSoyad ?? this.adSoyad,
      durum: durum ?? this.durum,
    );
  }

  // UI
  int? get modelID => id;
  int get modelOgrenciId => ogrenciId;
  String get modelAdSoyad => adSoyad;
  String get modelDurum {
    switch (durum) {
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
}