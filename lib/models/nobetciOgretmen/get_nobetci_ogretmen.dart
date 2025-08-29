class GetNobetciOgretmenModel {
  final int id;
  final int okulId;
  final String dosyaYolu;
  final DateTime zaman;
  final String dosyaAdi;

  GetNobetciOgretmenModel({
    required this.id,
    required this.okulId,
    required this.dosyaYolu,
    required this.zaman,
    required this.dosyaAdi,
  });

  factory GetNobetciOgretmenModel.fromJson(Map<String, dynamic> json) {
    return GetNobetciOgretmenModel(
      id: json['Id'],
      okulId: json['OkulId'],
      dosyaYolu: json['DosyaYolu'],
      zaman: DateTime.parse(json['Zaman']),
      dosyaAdi: json['DosyaAdi'],
    );
  }

  // UI
  String get modelDosyaAdi => dosyaAdi;

  String get modelTarih =>
      "${zaman.day.toString().padLeft(2, '0')}.${zaman.month.toString().padLeft(2, '0')}.${zaman.year}";

  String get modelAy => "${zaman.year}-${zaman.month.toString().padLeft(2, '0')}";

  String get modelHafta {
    final firstDayOfYear = DateTime(zaman.year, 1, 1);
    final daysSinceStart = zaman.difference(firstDayOfYear).inDays;
    final weekNumber = ((daysSinceStart + firstDayOfYear.weekday) / 7).ceil();
    return "${zaman.year}-H$weekNumber";
  }

  String get modelLink => dosyaYolu;
}