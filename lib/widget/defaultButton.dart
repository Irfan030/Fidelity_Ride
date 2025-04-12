import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/theme/sizeConfig.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final Color borderColor;
  final bool? loading;

  const DefaultButton({
    super.key,
    required this.text,
    required this.press,
    this.loading = false,

    this.backgroundColor = AppColor.mainColor,
    this.textColor = AppColor.whiteColor,
    this.borderRadius = 10,
    this.borderColor = AppColor.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!loading!) press();
      },
      child: Container(
        height: getProportionateScreenHeight(45),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Center(
          child:
              loading!
                  ? const CircularProgressIndicator(color: AppColor.whiteColor)
                  : Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontFamily: "PoppinsMedium",
                    ),
                  ),
        ),
      ),
    );
  }
}
