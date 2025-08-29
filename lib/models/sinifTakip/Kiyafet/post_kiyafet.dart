class PostKiyafetModel {
  final int? id;
  final int? ogrenciId;
  final String? tarih;
  final int altKiyafet;
  final int ustKiyafet;
  final int altCamasir;
  final int ustCamasir;
  final int? personelId;

  PostKiyafetModel({
    this.id,
    this.ogrenciId,
    this.tarih,
    required this.altKiyafet,
    required this.ustKiyafet,
    required this.altCamasir,
    required this.ustCamasir,
    this.personelId,
  });

  Map<String, dynamic> toJson() {
    if (id != null) {
      // Güncelleme modu (sadece id yeterli olabilir, ama durum yok burada)
      return {
        "id": id,
        "ogrenci_id": ogrenciId,
        "tarih": tarih,
        "alt_kiyafet": altKiyafet,
        "ust_kiyafet": ustKiyafet,
        "alt_camasir": altCamasir,
        "ust_camasir": ustCamasir,     
         if (personelId != null) 'personel_id': personelId,

      };
    } else {
      // Yeni kayıt modu (tüm veriler gerekli)
      return {
        "ogrenci_id": ogrenciId,
        "tarih": tarih,
        "alt_kiyafet": altKiyafet,
        "ust_kiyafet": ustKiyafet,
        "alt_camasir": altCamasir,
        "ust_camasir": ustCamasir,
      if (personelId != null) 'personel_id': personelId,
      };
    }
  }
}