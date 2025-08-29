class PostBoyKiloModel {
  final int? id; // opsiyonel, update için
  final int ogrenciId;
  /* final int boy;
  final int kilo; */
  final double boy; // <- double
  final double kilo; // <- double
  final String aciklama;
  final String tarih; // opsiyonel

  PostBoyKiloModel({
    this.id,
    required this.ogrenciId,
    required this.boy,
    required this.kilo,
    required this.aciklama,
    required this.tarih,
  });

  factory PostBoyKiloModel.fromJson(Map<String, dynamic> json) {
    return PostBoyKiloModel(
      id: json['Id'],
      ogrenciId: json['ogrenciId'],
      boy: json['boy'],
      kilo: json['kilo'],
      aciklama: json['aciklama'],
      tarih: json['tarih'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'ogrenciId': ogrenciId,
      'boy': boy,
      'kilo': kilo,
      'aciklama': aciklama,
    };
    if (id != null) data['Id'] = id;
    return data;
  }
}
