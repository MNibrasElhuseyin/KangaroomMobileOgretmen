class GetKarne {
  final int id;
  final int donem;
  final String gelisimTur;
  final String gelisimAlani;
  final int puan;

  GetKarne({
    required this.id,
    required this.donem,
    required this.gelisimTur,
    required this.gelisimAlani,
    required this.puan,
  });

  factory GetKarne.fromJson(Map<String, dynamic> json) {
    return GetKarne(
      id: json['id'],
      donem: json['Donem'],
      gelisimTur: json['GelisimTurAd'],
      gelisimAlani: json['GelisimAd'],
      puan: json['Puan'],
    );
  }

  // UI için okunabilir puan açıklaması
  String get modelPuan {
    switch (puan) {
      case 1:
        return "Yetersiz";
      case 2:
        return "Normal";
      case 3:
        return "İyi";
      case 4:
        return "Çok İyi";
      default:
        return "Bilinmeyen";
    }
  }

  //UI
  int get modelID => id;
  String get modelGelisimTur => gelisimTur;
  String get modelGelisimAlani => gelisimAlani;
}
