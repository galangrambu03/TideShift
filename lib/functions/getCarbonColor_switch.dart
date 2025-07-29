import 'dart:ui';

import 'package:flutter/material.dart';

Color getCarbonColor(int level) {
  switch (level) {
    case 1:
      return Colors.green[800]!; // very low
    case 2:
      return Colors.green;       // low
    case 3:
      return Colors.yellow[700]!; // medium
    case 4:
      return Colors.orange;      // high
    case 5:
      return Colors.red;         // very high
    default:
      return Colors.grey;        // fallback
  }
}
