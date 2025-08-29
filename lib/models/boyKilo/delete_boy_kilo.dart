class DeleteBoyKiloModel {
  final int id;

  DeleteBoyKiloModel({required this.id});

  factory DeleteBoyKiloModel.fromJson(Map<String, dynamic> json) {
    return DeleteBoyKiloModel(id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
