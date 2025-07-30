class FuzzyModel {
  final double totalCarbon;
  final int carbonLevel;
  final int islandPath;
  final Map<String, dynamic> emissionCategory;
  final FuzzyAnalysis fuzzyAnalysis;
  final List<String> improvementSuggestions;
  final int historicalDataPoints;

  FuzzyModel({
    required this.totalCarbon,
    required this.carbonLevel,
    required this.islandPath,
    required this.emissionCategory,
    required this.fuzzyAnalysis,
    required this.improvementSuggestions,
    required this.historicalDataPoints,
  });

  factory FuzzyModel.fromJson(Map<String, dynamic> json) {
    return FuzzyModel(
      totalCarbon: json['totalcarbon'],
      carbonLevel: json['carbonLevel'],
      islandPath: json['carbonLevel'] - 1,
      emissionCategory: json['emission_category'],
      fuzzyAnalysis: FuzzyAnalysis.fromJson(json['fuzzy_analysis']),
      improvementSuggestions: List<String>.from(
        json['improvement_suggestions'],
      ),
      historicalDataPoints: json['historical_data_points'],
    );
  }
}

class FuzzyAnalysis {
  final Map<String, double> suggestions;
  final double potentialSavings;
  final Map<String, double> normalValues;

  FuzzyAnalysis({
    required this.suggestions,
    required this.potentialSavings,
    required this.normalValues,
  });

  factory FuzzyAnalysis.fromJson(Map<String, dynamic> json) {
    return FuzzyAnalysis(
      suggestions: Map<String, double>.from(
        json['suggestions'].map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
      potentialSavings: (json['potential_savings'] as num).toDouble(),
      normalValues: Map<String, double>.from(
        json['normal_values'].map((k, v) => MapEntry(k, (v as num).toDouble())),
      ),
    );
  }
}
