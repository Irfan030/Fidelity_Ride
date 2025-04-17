// ignore_for_file: deprecated_member_use

import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/theme/sizeConfig.dart';
import 'package:fidelityride/widget/defaultButton.dart';
import 'package:flutter/material.dart';

class PhoneVerification extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  var appBarHeight = 0.0;
  var otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 14, left: 14),
            child: Column(
              children: <Widget>[
                SizedBox(height: appBarHeight),
                Row(
                  children: <Widget>[
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: appBarHeight),
                Text(
                  'Phone Verification',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Enter your OTP code here',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: getOtpTextUI(otpText: otpController.text),
                      ),
                      Opacity(
                        opacity: 0.0,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextField(
                                          controller: otpController,
                                          maxLength: 4,
                                          onChanged: (String txt) {
                                            setState(() {});
                                          },
                                          onTap: () {},
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                          decoration: InputDecoration(
                                            errorText: null,
                                            border: InputBorder.none,
                                            labelStyle: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                            ),
                                            counterText: "",
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                SizedBox(
                  width: SizeConfig.screenWidth / 2,

                  child: DefaultButton(
                    text: "VERIFY NOW",
                    backgroundColor: AppColor.secondaryColor,
                    borderColor: AppColor.secondaryColor,
                    press: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutePath.mainScreen,
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getOtpTextUI({String otpText = ""}) {
    List<Widget> otplist = [];
    Widget getUI({String otxt = ""}) {
      return Expanded(
        child: Column(
          children: <Widget>[
            SizedBox(height: 12),
            Text(
              otxt,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 2.5,
                width: 50,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ],
        ),
      );
    }

    for (var i = 0; i < 4; i++) {
      otplist.add(getUI(otxt: otpText.length > i ? otpText[i] : ""));
    }
    return Row(children: otplist);
  }
}
