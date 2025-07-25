class FactModel {
  final int id;
  final String content;

  FactModel({required this.id, required this.content});

  factory FactModel.fromJson(Map<String, dynamic> json) {
    return FactModel(
      id: json['id'],
      content: json['content'],
    );
  }
}
