import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/widget/titleWidget.dart';
import 'package:flutter/material.dart';

class TextIconButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final double fontSize;
  final String fontFamily;
  final double letterSpacing;
  final TextAlign textAlign;
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  const TextIconButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = AppColor.textButtonColor,
    this.fontSize = 12,
    this.fontFamily = "PoppinsRegular",
    this.letterSpacing = 0,
    this.textAlign = TextAlign.right,
    this.icon = Icons.chevron_right,
    this.iconSize = 14,
    this.iconColor = AppColor.textButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleWidget(
            val: text,
            color: textColor,
            fontSize: fontSize,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
          ),

          Icon(icon, size: iconSize, color: iconColor),
        ],
      ),
    );
  }
}
