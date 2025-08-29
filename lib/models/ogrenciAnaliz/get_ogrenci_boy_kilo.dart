class GetOgrenciBoyKilo {
  final DateTime tarih;
  final double boy;
  final double kilo;

  GetOgrenciBoyKilo({
    required this.tarih,
    required this.boy,
    required this.kilo,
  });

  factory GetOgrenciBoyKilo.fromJson(Map<String, dynamic> json) {
    return GetOgrenciBoyKilo(
      tarih: DateTime.parse(json['Tarih']),
      boy: json['Boy'],
      kilo: json['Kilo'],
    );
  }

  // UI
  double get modelKilo => kilo;
  double get modelBoy => boy;
  DateTime get modelTarih => tarih;
}
