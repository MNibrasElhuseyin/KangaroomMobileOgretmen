class GetYoklamaModel {
  final int? id;
  final int? ogrenciId;
  final String adSoyad;
  final int? durum;

  GetYoklamaModel({
    required this.id,
    required this.ogrenciId,
    required this.adSoyad,
    required this.durum,
  });

  factory GetYoklamaModel.fromJson(Map<String, dynamic> json) {
    return GetYoklamaModel(
      id:
          json['ID'] is int
              ? json['ID']
              : (json['ID'] == null
                  ? null
                  : int.tryParse(json['ID'].toString())),
      ogrenciId:
          json['OgrenciId'] is int
              ? json['OgrenciId']
              : (json['OgrenciId'] == null
                  ? null
                  : int.tryParse(json['OgrenciId'].toString())),
      adSoyad: json['OgrenciAdSoyad'] ?? '',
      durum:
          json['Durum'] is int
              ? json['Durum']
              : (json['Durum'] == null
                  ? null
                  : int.tryParse(json['Durum'].toString())),
    );
  }

  //UI
  int? get modelID => id;
  int? get modelOgrenciId => ogrenciId;
  String get modelAdSoyad => adSoyad;
  String get modelDurum => durum == 1 ? "Geldi" : "Gelmedi";
}
