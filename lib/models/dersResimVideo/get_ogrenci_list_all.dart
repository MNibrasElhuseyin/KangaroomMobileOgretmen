class GetOgrenciListAllModel {
  final int id;
  final String ad;
  final String soyad;

  GetOgrenciListAllModel({
    required this.id,
    required this.ad,
    required this.soyad,
  });

  factory GetOgrenciListAllModel.fromJson(Map<String, dynamic> json) {
    return GetOgrenciListAllModel(
      id: json['Id'],
      ad: json['Ad'],
      soyad: json['Soyad'],
    );
  }

  //UI
  int get modelID => id;
  String get modelAdSoyad => id == -1 ? 'Tüm Sınıf' : '$ad $soyad';
}