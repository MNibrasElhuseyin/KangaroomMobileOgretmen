class GetGelisimTurListModel {
  final int id;
  final String ad;

  GetGelisimTurListModel({
    required this.id,
    required this.ad,
  });

  factory GetGelisimTurListModel.fromJson(Map<String, dynamic> json) {
    return GetGelisimTurListModel(
      id: json['Id'],
      ad: json['Ad'],
    );
  }

  //UI
  int get modelID => id;
  String get modelAdSoyad => ad;
}