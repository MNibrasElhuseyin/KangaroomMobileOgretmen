/* class BoyKiloModel {
  final int id;
  final int ogrenciId;
  final String tarih;
  /* final int boy;
  final int kilo; */
  final double boy; // <- double
  final double kilo; // <- double
  final String? aciklama;
  final String ad;
  final String soyad;

  BoyKiloModel({
    required this.id,
    required this.ogrenciId,
    required this.tarih,
    required this.boy,
    required this.kilo,
    this.aciklama,
    required this.ad,
    required this.soyad,
  });

  factory BoyKiloModel.fromJson(Map<String, dynamic> json) {
    return BoyKiloModel(
      id: json['Id'],
      ogrenciId: json['OgrenciId'],
      tarih: json['Tarih'],
      boy: json['Boy'],
      kilo: json['Kilo'],
      aciklama: json['Aciklama'],
      ad: json['Ad'],
      soyad: json['Soyad'],
    );
  }

  //UI
  int get modelID => id;
  String get modelAdSoyad => '$ad $soyad';
  String get modelTarih => tarih;
  double get modelBoy => boy;
  double get modelKilo => kilo;
  String get modelAciklama => aciklama ?? '';
}
 */
class BoyKiloModel {
  final int id;
  final int ogrenciId;
  final String? tarih; // <- nullable
  final double boy;
  final double kilo;
  final String? aciklama;
  final String ad;
  final String soyad;

  BoyKiloModel({
    required this.id,
    required this.ogrenciId,
    required this.tarih,
    required this.boy,
    required this.kilo,
    required this.aciklama,
    required this.ad,
    required this.soyad,
  });

  factory BoyKiloModel.fromJson(Map<String, dynamic> json) {
    // Toleranslı okuma: eksik/yanlış tip gelirse default ver
    int _asInt(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
    double _asDouble(dynamic v) =>
        v is num ? v.toDouble() : double.tryParse(v?.toString() ?? '') ?? 0;

    return BoyKiloModel(
      id: _asInt(json['Id']),
      ogrenciId: _asInt(json['OgrenciId']),
      tarih: json['Tarih']?.toString(), // <- null olabilir
      boy: _asDouble(json['Boy']),
      kilo: _asDouble(json['Kilo']),
      aciklama: json['Aciklama']?.toString(),
      ad: (json['Ad'] ?? '').toString(),
      soyad: (json['Soyad'] ?? '').toString(),
    );
  }
}
