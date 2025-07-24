import 'package:ecomagara/config/colors.dart';
import 'package:flutter/material.dart';

Widget defaultButton({
  required String text,
  required VoidCallback onPressed,
  Color? color,
  double? width,
  Gradient? gradient,
}) {
  return SizedBox(
    height: 45,
    width: width ?? double.infinity,
    child: Container(
      decoration: BoxDecoration(
        color: gradient == null ? color ?? AppColors.primary : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: AppColors.surface),
        ),
      ),
    ),
  );
}
