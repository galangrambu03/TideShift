class DiyModel {
  final int id;
  final String title;
  final List<String> materials;
  final List<String> steps;
  final String image; // array of strings
  final String youtube;
  final String description;

  DiyModel({
    required this.id,
    required this.title,
    required this.materials,
    required this.steps,
    required this.image,
    required this.youtube,
    required this.description,
  });

  factory DiyModel.fromJson(Map<String, dynamic> json) {
    return DiyModel(
      id: json['id'],
      title: json['title'],
      materials: List<String>.from(json['materials']),
      steps: List<String>.from(json['steps']),
      image: json['image'],
      youtube: json['youtube'],
      description: json['description']
    );
  }
}
