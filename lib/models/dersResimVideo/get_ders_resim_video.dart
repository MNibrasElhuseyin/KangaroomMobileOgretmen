class GetDersResimVideoModel {
  final String ogrenciAd;
  final String ogrenciSoyad;
  final String dersAd;
  final String dersAciklama;
  final int dosyaSayisi;

  GetDersResimVideoModel({
    required this.ogrenciAd,
    required this.ogrenciSoyad,
    required this.dersAd,
    required this.dersAciklama,
    required this.dosyaSayisi,
  });

  factory GetDersResimVideoModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      // JSON tamamen boş gelebilir
      return GetDersResimVideoModel(
        ogrenciAd: '',
        ogrenciSoyad: '',
        dersAd: '',
        dersAciklama: '',
        dosyaSayisi: 0,
      );
    }

    // ogrenciAdSoyad'ı parçala
    final String adSoyad = json['ogrenciAdSoyad'] ?? '';
    final parts = adSoyad.trim().split(' ');
    final ad = parts.isNotEmpty ? parts.first : '';
    final soyad = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return GetDersResimVideoModel(
      ogrenciAd: ad,
      ogrenciSoyad: soyad,
      dersAd: json['dersAd'] ?? '',
      dersAciklama: json['aciklama'] ?? '',
      dosyaSayisi: json['dosyaSayi'] ?? 0,
    );
  }

  // UI helper'lar
  String get modelAdSoyad => '$ogrenciAd $ogrenciSoyad'.trim();
  String get modelDersAd => dersAd;
  String get modelDersAciklama => dersAciklama;
  int get modelDosyaSayi => dosyaSayisi;
}