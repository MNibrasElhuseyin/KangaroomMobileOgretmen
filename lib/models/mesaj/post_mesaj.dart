class PostMesajModel {
  final String icerik;
  final int ogrenciID;

  PostMesajModel({
    required this.icerik,
    required this.ogrenciID
  });

  factory PostMesajModel.fromJson(Map<String, dynamic> json) => PostMesajModel(
    icerik: json['icerik'] as String,
    ogrenciID: json['ogrenci_id'] as int,
  );

  Map<String, dynamic> toJson() => {
    'icerik': icerik,
    'ogrenci_id': ogrenciID,
  };
}