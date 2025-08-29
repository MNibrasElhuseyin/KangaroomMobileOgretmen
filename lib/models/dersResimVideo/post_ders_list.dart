class PostDersListModel {
  final String ad;
  final int personelId;
  final String? aciklama; // nullable

  PostDersListModel({
    required this.ad,
    required this.personelId,
    this.aciklama,
  });

  Map<String, dynamic> toJson() {
    final data = {
      "Ad": ad,
       if (personelId != 0) 'personel_id': personelId,

    };
    if (aciklama != null) {
      data["Aciklama"] = aciklama!;
    }
    return data;
  }
}