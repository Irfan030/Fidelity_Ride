import 'package:fidelityride/constant.dart';
import 'package:fidelityride/theme/colors.dart' show AppColor;
import 'package:fidelityride/widget/titleWidget.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;

  const HomeAppBar({super.key, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: AppColor.mainColor),
      ),
      leadingWidth: MediaQuery.of(context).size.width,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleWidget(
                    val: 'Richard Wilson',
                    color: AppColor.whiteColor,
                    fontFamily: AppData.poppinsSemiBold,
                    fontSize: 20,
                  ),
                  TitleWidget(
                    val: 'Manager',
                    color: AppColor.whiteColor,
                    fontFamily: AppData.poppinsRegular,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.blueColor,
              child: const TitleWidget(
                val: 'R',
                color: AppColor.whiteColor,
                fontFamily: 'OpenSansRegular',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
