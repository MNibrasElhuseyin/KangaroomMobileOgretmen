class PostDersResimVideoModel {
  final int dersId;
  final int ogrenciId;
  final List<String> files;

  PostDersResimVideoModel({
    required this.dersId,
    required this.ogrenciId,
    required this.files,
  });

  Map<String, dynamic> toJson() {
    return {
      "ders_id": dersId,
      "ogrenci_id": ogrenciId,
      "files": files,
    };
  }
}