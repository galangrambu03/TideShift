class DailyGoalItemModel {
  final String type; // 'numeric', 'positive', or 'negative'
  final String field;
  final String title;
  final double? value;
  final String? unit;

  DailyGoalItemModel({
    required this.type,
    required this.field,
    required this.title,
    this.value,
    this.unit,
  });

  factory DailyGoalItemModel.fromJson(Map<String, dynamic> json) {
    return DailyGoalItemModel(
      type: json['type'],
      field: json['field'],
      title: json['title'],
      value: (json['value'] != null) ? (json['value'] as num).toDouble() : null,
      unit: json['unit'],
    );
  }
}
