class GetEtkinlikOnay {
  final String tarih;
  final String etkinlikAd;
  final String ogrenciAd;
  final String durum;

  GetEtkinlikOnay({
    required this.tarih,
    required this.etkinlikAd,
    required this.ogrenciAd,
    required this.durum,
  });

  factory GetEtkinlikOnay.fromJson(Map<String, dynamic> json) {
    return GetEtkinlikOnay(
      tarih: json['Tarih'],
      etkinlikAd: json['EtkinlikAd'],
      ogrenciAd: json['OgrenciAd'],
      durum: json['Durum'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Tarih': tarih,
      'EtkinlikAd': etkinlikAd,
      'OgrenciAd': ogrenciAd,
      'Durum': durum,
    };
  }

  //UI
  String get modelTarih => tarih;
  String get modelEtkinlikAd => etkinlikAd;
  String get modelOgrenciAd => ogrenciAd;
  String get modelDurum => durum;
}
