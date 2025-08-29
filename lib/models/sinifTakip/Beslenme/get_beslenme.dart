class GetBeslenmeModel {
  final int? id;
  final int ogrenciId;
  final String adSoyad;
  int durum; // Değiştirilebilir
  final int ogun;

  GetBeslenmeModel({
    required this.id,
    required this.ogrenciId,
    required this.adSoyad,
    required this.durum,
    required this.ogun,
  });

  factory GetBeslenmeModel.fromJson(Map<String, dynamic> json) {
    return GetBeslenmeModel(
      id: json['ID'] is int ? json['ID'] : int.tryParse(json['ID'].toString()),
      ogrenciId: json['OgrenciId'] is int ? json['OgrenciId'] : int.tryParse(json['OgrenciId'].toString()) ?? 0,
      adSoyad: json['OgrenciAdSoyad'] ?? '',
      durum: json['Durum'] is int ? json['Durum'] : int.tryParse(json['Durum'].toString()) ?? 0,
      ogun: json['Ogun'] is int ? json['Ogun'] : int.tryParse(json['Ogun'].toString()) ?? 0,
    );
  }

  // UI
  int get modelID => id ?? 0;
  int get modelOgrenciId => ogrenciId;
  String get modelAdSoyad => adSoyad;
  String get modelOgun {
    switch (ogun) {
      case 0:
        return 'Sabah';
      case 1:
        return 'Öğle';
      case 2:
        return 'İkindi';
      default:
        return 'Bilinmiyor';
    }
  }

  String get modelDurum {
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
}