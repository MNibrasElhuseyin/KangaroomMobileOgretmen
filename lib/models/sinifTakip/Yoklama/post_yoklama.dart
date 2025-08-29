class PostYoklamaModel {
  final int? id; // Opsiyonel (null olabilir)
  final int? ogrenciId;
  final String? tarih;
  int durum; // Final kaldırıldı
  final String? personelId;

  PostYoklamaModel({
    this.id,
    this.ogrenciId,
    this.tarih,
    required this.durum,
    this.personelId,
  });

  // JSON'a çevirme
  Map<String, dynamic> toJson() {
    if (id != null) {
      // Güncelleme modu (sadece id ve durum yeterli)
      return {
        "id": id,
        "durum": durum,
      };
    } else {
      // Yeni kayıt modu (tüm veriler gerekli)
      return {
        "ogrenci_id": ogrenciId,
        "tarih": tarih,
        "durum": durum,
      if (personelId != null) 'personel_id': personelId,
      };
    }
  }
}