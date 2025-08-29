class GetProfilModel {
  final String ad;
  final String soyad;
  final String iletisim;

  GetProfilModel({
    required this.ad,
    required this.soyad,
    required this.iletisim,
  });

  factory GetProfilModel.fromJson(Map<String, dynamic> json) {
    return GetProfilModel(
      ad: json['Ad'] ?? '',
      soyad: json['Soyad'] ?? '',
      iletisim: json['Iletisim'] ?? '',
    );
  }

  // UI
  String get modelAd => ad;
  String get modelSoyad => soyad;
  String get modelIletisim => iletisim;
}