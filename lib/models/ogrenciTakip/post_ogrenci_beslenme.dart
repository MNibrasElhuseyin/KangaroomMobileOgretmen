class PostOgrenciBeslenmeModel {
  final int? id;
  final int? ogrenciId;
  final String? tarih;
  final int? ogun;
  final int durum;
  final int? personelId;

  PostOgrenciBeslenmeModel({
    this.id,
    this.ogrenciId,
    this.tarih,
    this.ogun,
    required this.durum,
    this.personelId,
  });

  factory PostOgrenciBeslenmeModel.fromJson(Map<String, dynamic> json) {
    return PostOgrenciBeslenmeModel(
      id: json['id'] as int?,
      ogrenciId: json['ogrenci_id'] as int?,
      tarih: json['tarih'] as String?,
      ogun: json['ogun'] as int?,
      durum: json['durum'] as int,
      personelId: json['personel_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (ogrenciId != null) 'ogrenci_id': ogrenciId,
      if (tarih != null) 'tarih': tarih,
      if (ogun != null) 'ogun': ogun,
      'durum': durum,
      if (personelId != null) 'personel_id': personelId,
    };
  }
}
