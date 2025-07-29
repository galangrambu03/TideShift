import 'package:ecomagara/config/colors.dart';
import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? color;
  final Gradient? gradient;
  final bool? showCarbonSaved;
  final String? carbonSaved;

  const GoalCard({
    super.key,
    required this.text,
    this.textColor,
    this.color,
    this.gradient,
    this.showCarbonSaved = false,
    this.carbonSaved,
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
      child:
          (showCarbonSaved ?? false)
              ? Column(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Row(
                  //   children: [
                  //     Icon(Icons.eco, color: AppColors.navbarIcon, size: 15,),
                  //     SizedBox(width: 5),
                  //     Text(
                  //       "Save $carbonSaved kgCO2",
                  //       style: TextStyle(color: AppColors.navbarIcon, fontSize: 13),
                  //     ),
                  //   ],
                  // ),
                ],
              )
              : Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
    );
  }
}
