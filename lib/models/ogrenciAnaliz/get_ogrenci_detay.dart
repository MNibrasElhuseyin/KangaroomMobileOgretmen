class GetOgrenciDetayModel {
  final int id;
  final String tc;
  final String ad;
  final String soyad;
  final String dogumTarihi;
  final String anneAd;
  final String babaAd;
  final String? digerKisiAd;
  final String ilacAdi;
  final String ilacSaati;
  final String sinifAd;
  final String hastalik;
  final String alerji;

  GetOgrenciDetayModel({
    required this.id,
    required this.tc,
    required this.ad,
    required this.soyad,
    required this.dogumTarihi,
    required this.anneAd,
    required this.babaAd,
    this.digerKisiAd,
    required this.ilacAdi,
    required this.ilacSaati,
    required this.sinifAd,
    required this.hastalik,
    required this.alerji,
  });

  factory GetOgrenciDetayModel.fromJson(Map<String, dynamic> json) {
    return GetOgrenciDetayModel(
      id: json['Id'],
      tc: json['TC'],
      ad: json['Ad'],
      soyad: json['Soyad'],
      dogumTarihi: json['DogumTarihi'],
      anneAd: json['AnneAd'],
      babaAd: json['BabaAd'],
      digerKisiAd: json['DigerKisiAd'],
      ilacAdi: json['ilacAdi'],
      ilacSaati: json['ilacSaati'],
      sinifAd: json['SinifAd'],
      hastalik: json['Hastalik'],
      alerji: json['Alerji'],
    );
  }

  // UI için getter'lar
  String get modelTC => tc;
  String get modelAd => ad;
  String get modelSoyad => soyad;
  String get modelDogumTarih => dogumTarihi.isEmpty ? '' : dogumTarihi.split('-').reversed.join('.');
  String get modelAnneAd => anneAd;
  String get modelBabaAd => babaAd;
  String get modelTeslimAlacakad => digerKisiAd ?? '';
  String get modelIlacAd => ilacAdi;
  String get modelIlacSaat => ilacSaati.split('.').first.split('T').last.substring(0,5);
  String get modelSinif => sinifAd;
  String get modelHastalik => hastalik;
  String get modelAlerji => alerji;
}
