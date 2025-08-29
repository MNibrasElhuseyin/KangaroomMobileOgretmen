class GetKiyafetTalepModel {
  final String ad;
  final String soyad;
  final String icerik;
  final String tarih;

  GetKiyafetTalepModel({
    required this.ad,
    required this.soyad,
    required this.icerik,
    required this.tarih
  });

  factory GetKiyafetTalepModel.fromJson(Map<String, dynamic> json) {
    return GetKiyafetTalepModel(
      ad: json['ad'],
      soyad: json['soyad'],
      icerik: json['icerik'],
      tarih: json['tarih']
    );
  }

  String get modelOgrenciAdSoyad => '$ad $soyad';
  String get modelTarih => tarih;
  String get modelIcerik => icerik;
}
