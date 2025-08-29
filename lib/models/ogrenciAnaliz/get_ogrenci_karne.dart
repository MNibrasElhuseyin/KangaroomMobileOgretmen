class GetOgrenciKarne {
  final int donem;
  final String gelisimTur;
  final String gelisimAlani;
  final int puan;

  GetOgrenciKarne({
    required this.donem,
    required this.gelisimTur,
    required this.gelisimAlani,
    required this.puan,
  });

  factory GetOgrenciKarne.fromJson(Map<String, dynamic> json) {
    return GetOgrenciKarne(
      donem: json['Donem'],
      gelisimTur: json['GelisimTur'],
      gelisimAlani: json['GelisimAlani'],
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
  String get modelGelisimTur => gelisimTur;
  String get modelGelisimAlani => gelisimAlani;
}
