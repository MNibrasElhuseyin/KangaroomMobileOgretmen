class GetIlacModel {
  final int? id;
  final int ogrenciId; // Yeni eklenen alan
  final String adSoyad;
  final String ilac;
  final String saat;
  int durum; // Değiştirilebilir

  GetIlacModel({
    required this.id,
    required this.ogrenciId,
    required this.adSoyad,
    required this.ilac,
    required this.saat,
    required this.durum,
  });

  factory GetIlacModel.fromJson(Map<String, dynamic> json) {
    return GetIlacModel(
      id: json['ID'] is int ? json['ID'] : int.tryParse(json['ID'].toString()),
      ogrenciId: json['OgrenciId'] is int ? json['OgrenciId'] : int.tryParse(json['OgrenciId'].toString()) ?? 0,
      adSoyad: json['OgrenciAdSoyad'] ?? '',
      ilac: json['Ilac'] ?? '',
      saat: json['Saat'] ?? '',
      durum: json['Durum'] is int ? json['Durum'] : int.tryParse(json['Durum'].toString()) ?? 0,
    );
  }

  // UI
  int get modelID => id ?? 0;
  int get modelOgrenciId => ogrenciId;
  String get modelAdSoyad => adSoyad;
  String get modelIlac => ilac;
  String get modelSaat => saat;
  String get modelDurum => durum == 1 ? "İçti" : "İçmedi";
}