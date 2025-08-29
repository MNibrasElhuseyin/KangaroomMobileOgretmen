class PostIlacModel {
  final int? id; // Opsiyonel, varsa update modu
  final int? ogrenciId;
  final String? ilac;
  final String? icerik;
  final String? saat;
  final int durum;
  final int? personelId;

  PostIlacModel({
    this.id,
    this.ogrenciId,
    this.ilac,
    this.icerik,
    this.saat,
    required this.durum,
    this.personelId,
  });

  Map<String, dynamic> toJson() {
    if (id != null) {
      // Güncelleme modu: sadece id ve durum yeterli
      return {
        "id": id,
        "durum": durum,
      };
    } else {
      // Yeni kayıt modu: tüm veriler gerekli
      return {
        "ogrenci_id": ogrenciId,
        "ilac": ilac,
        "icerik": icerik,
        "saat": saat,
        "durum": durum,
        if (personelId != null) 'personel_id': personelId,
      };
    }
  }
}