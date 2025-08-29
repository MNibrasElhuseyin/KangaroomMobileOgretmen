class PatchEtkinlikTanimlamaModel {
  final int id;
  final String tarih; // "yyyy-MM-dd"
  final String saat; // "HH:mm"
  final String ad;
  final String tutar; // double'dan String'e güncellendi (varchar için)
  final String aciklama;

  PatchEtkinlikTanimlamaModel({
    required this.id,
    required this.tarih,
    required this.saat,
    required this.ad,
    required this.tutar,
    required this.aciklama,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "tarih": tarih,
      "saat": saat,
      "ad": ad,
      "tutar": tutar, // String olarak gönderilecek
      "aciklama": aciklama,
    };
  }
}
