import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String val;
  final Color color;
  final double fontSize;
  final String fontFamily;
  final double letterSpacing;

  const TitleWidget({
    super.key,
    required this.val,
    this.color = AppColor.blackColor,
    this.fontSize = 14,
    this.fontFamily = "OpenSansRegular",
    this.letterSpacing = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      val,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
