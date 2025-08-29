class PostKarne {
  final int? id;
  final int puan;
  final int? ogrenciId;
  final int? gelisimId;
  final int? donem;

  PostKarne({
    this.id,
    required this.puan,
    this.ogrenciId,
    this.gelisimId,
    this.donem,
  });

  factory PostKarne.fromJson(Map<String, dynamic> json) => PostKarne(
    id: json['id'] as int?,
    puan: json['puan'] as int,
    ogrenciId: json['ogrenci_id'] as int?,
    gelisimId: json['gelisim_id'] as int?,
    donem: json['donem'] as int?,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'puan': puan,
    if (ogrenciId != null) 'ogrenci_id': ogrenciId,
    if (gelisimId != null) 'gelisim_id': gelisimId,
    if (donem != null) 'donem': donem,
  };
}
