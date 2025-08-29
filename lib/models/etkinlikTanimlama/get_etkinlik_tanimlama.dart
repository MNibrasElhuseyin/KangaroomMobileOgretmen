class GetEtkinlikTanimlamaModel {
  final int id;
  final String sinifAd;
  final int sinifId;
  final String tarih;
  final String saat;
  final String ad;
  final String tutar; // varchar olduğu için String
  final String aciklama;
  final String resimBinary; // ResimOzet olarak geliyor
  final String resim;

  GetEtkinlikTanimlamaModel({
    required this.id,
    required this.sinifAd,
    required this.sinifId,
    required this.tarih,
    required this.saat,
    required this.ad,
    required this.tutar,
    required this.aciklama,
    required this.resimBinary,
    required this.resim,
  });

  factory GetEtkinlikTanimlamaModel.fromJson(Map<String, dynamic> json) {
    print('JSON verisi: $json'); // Hata ayıklama
    // Saat'i "HH:mm" formatına çevir (ilk 5 karakter al)
    String formattedSaat = json['Saat']?.toString().substring(0, 5) ?? '00:00';
    return GetEtkinlikTanimlamaModel(
      id: json['Id'] ?? 0,
      sinifAd: json['SinifAd'] ?? '',
      sinifId: json['SinifId'] ?? 0,
      tarih: json['Tarih'] ?? '',
      saat: formattedSaat,
      ad: json['Ad'] ?? '',
      tutar: json['Tutar']?.toString() ?? '0', // int'ten string'e çevir
      aciklama: json['Aciklama'] ?? '',
      resimBinary: json['Resim'] ?? '',
      resim: json['Resim'] ?? '',
    );
  }

  int get modelID => id;
  String get modelSinif => sinifAd;
  int get modelSinifId => sinifId;
  String get modelTarih => tarih;
  String get modelSaat => saat;
  String get modelAd => ad;
  String get modelUcret => tutar;
  String get modelAciklama => aciklama;
  String get modelResim => resim;

}
