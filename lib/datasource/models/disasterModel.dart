class DisasterModel {
  final String id;
  final String disasterNames;
  final String description;
  final List<String> countries;
  final List<String> tips;
  final String image;

  DisasterModel({
    required this.id,
    required this.disasterNames,
    required this.description,
    required this.countries,
    required this.tips,
    required this.image
  });

  factory DisasterModel.fromJson(Map<String, dynamic> json) {
    return DisasterModel(
      id: json['id'].toString(),
      disasterNames: json['disasterNames'],
      description: json['description'],
      countries: List<String>.from(json['countries']),
      tips: List<String>.from(json['tips']),
      image: json['image']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'disasterNames': disasterNames,
      'description': description,
      'countries': countries,
      'tips': tips,
      'image' : image
    };
  }
}
