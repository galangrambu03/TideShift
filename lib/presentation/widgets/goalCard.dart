import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? color;
  final Gradient? gradient;

  const GoalCard({
    super.key,
    required this.text,
    this.textColor,
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(left: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gradient == null ? color ?? Colors.white : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
