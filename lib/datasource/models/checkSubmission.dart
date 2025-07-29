// models/checkSubmissionResult.dart
class CheckSubmissionResult {
  final int userId;
  final String dateChecked;
  final bool hasSubmitted;
  final String message;

  CheckSubmissionResult({
    required this.userId,
    required this.dateChecked,
    required this.hasSubmitted,
    required this.message,
  });

  factory CheckSubmissionResult.fromJson(Map<String, dynamic> json) {
    return CheckSubmissionResult(
      userId: json['user_id'],
      dateChecked: json['date_checked'],
      hasSubmitted: json['has_submitted'],
      message: json['message'],
    );
  }
}
