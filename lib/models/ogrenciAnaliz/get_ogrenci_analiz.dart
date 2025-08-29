class GetOgrenciAnaliz {
  final int id;
  final String adSoyad;
  final String sinif;

  GetOgrenciAnaliz({
    required this.id,
    required this.adSoyad,
    required this.sinif
  });

  factory GetOgrenciAnaliz.fromJson(Map<String, dynamic> json) {
    return GetOgrenciAnaliz(
      id: json['Id Stunu'],
      adSoyad: json['Ad Soyad'],
      sinif: json['Sınıf']
    );
  }

  //UI
  int get modelID => id;
  String get modelAdSoyad => adSoyad;
  String get modelSinif => sinif;
}
