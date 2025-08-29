class GetEtkinlikListModel {
  final int id;
  final String ad;

  GetEtkinlikListModel({
    required this.id,
    required this.ad,
  });

  factory GetEtkinlikListModel.fromJson(Map<String, dynamic> json) {
    return GetEtkinlikListModel(
      id: json['Id'],
      ad: json['Ad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Ad': ad,
    };
  }

  //UI
  String get modelAd => ad;
}
