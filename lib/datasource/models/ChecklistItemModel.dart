import 'package:get/get_rx/src/rx_types/rx_types.dart';

enum ChecklistType { boolean, numericInt, numericDouble }

class ChecklistItem {
  final String label;
  final ChecklistType type;
  final dynamic value;
  final double factor;
  final String? iconName;

  ChecklistItem({
    required this.label,
    required this.type,
    required this.value,
    required this.factor,
    this.iconName,
  });
}

