class PostOgrenciDuyguDurumModel {
  final int? id;
  final int? ogrenciId;
  final String? tarih;
  final int durum;
  final int? personelId;

  PostOgrenciDuyguDurumModel({
    this.id,
    this.ogrenciId,
    this.tarih,
    required this.durum,
    this.personelId,
  });

  factory PostOgrenciDuyguDurumModel.fromJson(Map<String, dynamic> json) {
    return PostOgrenciDuyguDurumModel(
      id: json['id'] as int?,
      ogrenciId: json['ogrenci_id'] as int?,
      tarih: json['tarih'] as String?,
      durum: json['durum'] as int,
      personelId: json['personel_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (ogrenciId != null) 'ogrenci_id': ogrenciId,
      if (tarih != null) 'tarih': tarih,
      'durum': durum,
      if (personelId != null) 'personel_id': personelId,
    };
  }
}