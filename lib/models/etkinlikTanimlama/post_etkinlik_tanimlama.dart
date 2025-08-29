class PostEtkinlikTanimlamaModel {
  final String tarih; // "yyyy-MM-dd"
  final String saat; // "HH:mm"
  final String ad;
  final String tutar; // double'dan String'e güncellendi (varchar için)
  final String aciklama;
  final String resim; // Base64 string
  final int durum; // 0: pasif, 1: aktif

  PostEtkinlikTanimlamaModel({
    required this.tarih,
    required this.saat,
    required this.ad,
    required this.tutar,
    required this.aciklama,
    required this.resim,
    this.durum = 1, // Varsayılan değeri 0
  });

  Map<String, dynamic> toJson() {
    return {
      "tarih": tarih,
      "saat": saat,
      "ad": ad,
      "tutar": tutar, // String olarak gönderilecek
      "aciklama": aciklama,
      "resim": resim,
      "durum": durum,
    };
  }
}
