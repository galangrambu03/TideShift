class CarbonUnit {
  final int id;
  final String label;
  final double carbonWeight;

  CarbonUnit({
    required this.id,
    required this.label,
    required this.carbonWeight,
  });

  factory CarbonUnit.fromJson(Map<String, dynamic> json) {
    return CarbonUnit(
      id: json['id'],
      label: json['label'],
      carbonWeight: (json['carbonWeight'] as num).toDouble(),
    );
  }
}
