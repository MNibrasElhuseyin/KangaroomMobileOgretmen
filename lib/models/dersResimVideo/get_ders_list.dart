class GetDersListModel {
  final int id;
  final String ad;

  GetDersListModel({
    required this.id,
    required this.ad,
  });

  factory GetDersListModel.fromJson(Map<String, dynamic> json) {
    return GetDersListModel(
      id: json['Id'],
      ad: json['Ad'],
    );
  }

  //UI
  int get modelID => id;
  String get modelAd => ad;
}