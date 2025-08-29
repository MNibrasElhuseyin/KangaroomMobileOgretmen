class GetOgrenciListModel {
  final int id;
  final String ad;
  final String soyad;

  GetOgrenciListModel({
    required this.id,
    required this.ad,
    required this.soyad,
  });

  factory GetOgrenciListModel.fromJson(Map<String, dynamic> json) {
    return GetOgrenciListModel(
      id: json['Id'],
      ad: json['Ad'],
      soyad: json['Soyad'],
    );
  }

  //UI
  String get modelAdSoyad => '$ad $soyad';
}