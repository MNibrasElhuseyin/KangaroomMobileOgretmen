class PostUykuModel {
  final int? id; // Opsiyonel, varsa update modu
  final int? ogrenciId;
  final String? tarih;
  final int durum;
  final int? personelId;

  PostUykuModel({
    this.id,
    this.ogrenciId,
    this.tarih,
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
        "durum": durum,
       if (personelId != null) 'personel_id': personelId,

      };
    }
  }
}