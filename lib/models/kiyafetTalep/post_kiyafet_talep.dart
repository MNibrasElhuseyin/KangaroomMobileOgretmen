class PostKiyafetModel {
  final int personelId;
  final int ogrenciId;
  final int ustKiyafet;
  final int altKiyafet;
  final int ustCamasir;
  final int altCamasir;
  final String aciklama;

  PostKiyafetModel({
    required this.personelId,
    required this.ogrenciId,
    required this.ustKiyafet,
    required this.altKiyafet,
    required this.ustCamasir,
    required this.altCamasir,
    required this.aciklama,
  });

  factory PostKiyafetModel.fromJson(Map<String, dynamic> json) {
    return PostKiyafetModel(
      personelId: json['personel_id'] as int,
      ogrenciId: json['ogrenci_id'] as int,
      ustKiyafet: json['ustKiyafet'] as int,
      altKiyafet: json['altKiyafet'] as int,
      ustCamasir: json['ustCamasir'] as int,
      altCamasir: json['altCamasir'] as int,
      aciklama: json['aciklama'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personel_id': personelId,
      'ogrenci_id': ogrenciId,
      'ustKiyafet': ustKiyafet,
      'altKiyafet': altKiyafet,
      'ustCamasir': ustCamasir,
      'altCamasir': altCamasir,
      'aciklama': aciklama,
    };
  }
}