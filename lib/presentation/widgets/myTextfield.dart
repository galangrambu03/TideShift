import 'package:ecomagara/config/colors.dart';
import 'package:flutter/material.dart';

Widget myTextField({
  required String hintText,
  required TextEditingController controller,
  IconButton? suffixIcon,
  bool obscureText = false,
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textGrey),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
      suffixIconColor: AppColors.textGrey,
    ),
  );
}
