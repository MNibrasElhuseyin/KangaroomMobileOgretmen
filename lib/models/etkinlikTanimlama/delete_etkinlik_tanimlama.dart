class DeleteEtkinlikTanimlamaModel {
  final int id;

  DeleteEtkinlikTanimlamaModel({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}