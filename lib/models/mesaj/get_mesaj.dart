class GetMesajModel {
  final String tarih;
  final String icerik;
  final String kimdenAdSoyad;
  final String kimeAdSoyad;
  final int gondericiTur;

  GetMesajModel({
    required this.tarih,
    required this.icerik,
    required this.kimdenAdSoyad,
    required this.kimeAdSoyad,
    required this.gondericiTur,
  });

  factory GetMesajModel.fromJson(Map<String, dynamic> json) {
    return GetMesajModel(
      tarih: json['tarih'],
      icerik: json['icerik'],
      kimdenAdSoyad: json['kimdenAdSoyad'],
      kimeAdSoyad: json['kimeAdSoyad'],
      gondericiTur: json['gondericiTur']
    );
  }

  // UI için örnek ad soyad
  String get modelTarih => tarih;
  String get modelIcerik => icerik;
  String get modelKimdenAdSoyad => kimdenAdSoyad;
  String get modelKimeAdSoyad => kimeAdSoyad;
  int get modelGondericiTur => gondericiTur;
}
