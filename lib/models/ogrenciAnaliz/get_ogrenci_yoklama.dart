class GetOgrenciYoklamaModel {
  final DateTime tarih;
  final bool durum;

  GetOgrenciYoklamaModel({required this.tarih, required this.durum});

  factory GetOgrenciYoklamaModel.fromJson(Map<String, dynamic> json) {
    return GetOgrenciYoklamaModel(
      tarih: DateTime.parse(json['Tarih']),
      durum: json['Durum'],
    );
  }

  // UI
  String get modelDurum => durum ? "Geldi" : "Gelmedi";
  DateTime get modelTarih => tarih;
}
