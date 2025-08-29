class GetGelisimListModel {
  final int id;
  final int tur;
  final String ad;

  GetGelisimListModel({
    required this.id,
    required this.tur,
    required this.ad,
  });

  factory GetGelisimListModel.fromJson(Map<dynamic, dynamic> json) {
    return GetGelisimListModel(
      id: json['Id'],
      tur: json['Tur'],
      ad: json['Ad'],
    );
  }

  //UI
  int get modelID => id;
  String get modelAd => ad;

  String get modelTur {
    switch (tur) {
      case 1:
        return 'Sosyal ve Duygusal Gelişim';
      case 2:
        return 'Bilişsel Gelişim';
      case 3:
        return 'Dil Gelişimi';
      case 4:
        return 'Motor Gelişimi';
      case 5:
        return 'Özbakım Becerisi';
      default:
        return 'Bilinmiyor';
    }
  }
}