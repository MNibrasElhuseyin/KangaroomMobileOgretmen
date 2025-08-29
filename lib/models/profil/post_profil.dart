class PostProfilModel {
  final int id;
  final String ad;
  final String soyad;
  final String sifre;

  PostProfilModel({
    required this.id,
    required this.ad,
    required this.soyad,
    required this.sifre,
  });

  factory PostProfilModel.fromJson(Map<String, dynamic> json) {
    return PostProfilModel(
      id: json['personel_id'],
      ad: json['ad'],
      soyad: json['soyad'],
      sifre: json['sifre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personel_id': id,
      'ad': ad,
      'soyad': soyad,
      'sifre': sifre,
    };
  }
}