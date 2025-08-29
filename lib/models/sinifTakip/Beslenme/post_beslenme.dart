class PostBeslenmeModel {
  final int? id; // Opsiyonel, varsa update modu
  final int? ogrenciId;
  final String? tarih;
  final int ogun;
  final int durum;
  final int? personelId;

  PostBeslenmeModel({
    this.id,
    this.ogrenciId,
    this.tarih,
    required this.ogun,
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
        "tarih": tarih,
        "ogun": ogun,
        "durum": durum,
        if (personelId != null) 'personel_id': personelId,
      };
    }
  }
}