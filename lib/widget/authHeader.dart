import 'package:fidelityride/constant.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/theme/sizeConfig.dart';
import 'package:fidelityride/widget/titleWidget.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function? backbutton;
  final bool showBackButton;

  const AuthHeader({
    super.key,
    required this.title,
    this.backbutton,
    required this.subtitle,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: AppColor.mainColor,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: statusBarHeight),
                GestureDetector(
                  onTap: () {
                    if (backbutton != null) {
                      backbutton!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 3),
                    child:
                        showBackButton
                            ? Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: getProportionateScreenHeight(23),
                              color: AppColor.whiteColor,
                            )
                            : Container(
                              height: getProportionateScreenHeight(21),
                            ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(25)),
                TitleWidget(
                  val: title,
                  color: AppColor.whiteColor,
                  fontSize: 32,
                  fontFamily: AppData.khandBold,
                ),
                Container(
                  margin: EdgeInsets.only(top: 7, bottom: 12),
                  child: TitleWidget(
                    val: subtitle,
                    color: AppColor.whiteColor,
                    fontSize: 14,
                    fontFamily: AppData.openSansRegular,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
