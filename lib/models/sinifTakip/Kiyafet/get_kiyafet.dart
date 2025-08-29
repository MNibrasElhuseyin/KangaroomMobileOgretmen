class GetKiyafetModel {
  final int? id;
  final int ogrenciId;
  final String adSoyad;
  final int ustKiyafet;
  final int altKiyafet;
  final int ustCamasir;
  final int altCamasir;

  GetKiyafetModel({
    required this.id,
    required this.ogrenciId,
    required this.adSoyad,
    required this.ustKiyafet,
    required this.altKiyafet,
    required this.ustCamasir,
    required this.altCamasir,
  });

  factory GetKiyafetModel.fromJson(Map<String, dynamic> json) {
    return GetKiyafetModel(
      id: json['ID'],
      ogrenciId: json['OgrenciId'],
      adSoyad: json['OgrenciAdSoyad'],
      ustKiyafet: json['UstKiyafet'],
      altKiyafet: json['AltKiyafet'],
      ustCamasir: json['UstCamasir'],
      altCamasir: json['AltCamasir'],
    );
  }

  //UI
  int? get modelID => id;
  int get modelOgrenciId => ogrenciId;
  String get modelAdSoyad => adSoyad;
  String get modelUstKiyafet =>
      ustKiyafet == 1 ? "Kıyafeti Var" : "Kıyafeti Yok";
  String get modelAltKiyafet =>
      altKiyafet == 1 ? "Kıyafeti Var" : "Kıyafeti Yok";
  String get modelUstCamasir =>
      ustCamasir == 1 ? "Kıyafeti Var" : "Kıyafeti Yok";
  String get modelAltCamasir =>
      altCamasir == 1 ? "Kıyafeti Var" : "Kıyafeti Yok";

  // Kopyalama metodu - yeni değerlerle model oluşturmak için
  GetKiyafetModel copyWith({
    int? id,
    int? ogrenciId,
    String? adSoyad,
    int? ustKiyafet,
    int? altKiyafet,
    int? ustCamasir,
    int? altCamasir,
  }) {
    return GetKiyafetModel(
      id: id ?? this.id,
      ogrenciId: ogrenciId ?? this.ogrenciId,
      adSoyad: adSoyad ?? this.adSoyad,
      ustKiyafet: ustKiyafet ?? this.ustKiyafet,
      altKiyafet: altKiyafet ?? this.altKiyafet,
      ustCamasir: ustCamasir ?? this.ustCamasir,
      altCamasir: altCamasir ?? this.altCamasir,
    );
  }
}