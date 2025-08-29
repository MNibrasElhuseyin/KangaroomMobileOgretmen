class GetBeslenmeProgramiModel {
  final String dosyaAdi;
  final String tarih;
  final String ay;
  final String hafta;
  final String link;

  GetBeslenmeProgramiModel({
    required this.dosyaAdi,
    required this.tarih,
    required this.ay,
    required this.hafta,
    required this.link,
  });

  factory GetBeslenmeProgramiModel.fromJson(Map<String, dynamic> json) {
    return GetBeslenmeProgramiModel(
      dosyaAdi: json['dosya_adi'],
      tarih: json['tarih'],
      ay: json['ay'],
      hafta: json['hafta'],
      link: json['link'],
    );
  }

  //UI
  String get modelDosyaAdi => dosyaAdi;
  String get modelTarih => tarih;
  String get modelAy => ay;
  String get modelHafta => hafta;
  String get modelLink => link;
}