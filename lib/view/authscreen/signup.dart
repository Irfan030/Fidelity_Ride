import 'package:animator/animator.dart';
import 'package:fidelityride/constant.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/theme/sizeConfig.dart';
import 'package:fidelityride/view/authscreen/login.dart';
import 'package:fidelityride/view/authscreen/otpscreen.dart';
import 'package:fidelityride/widget/defaultButton.dart';
import 'package:fidelityride/widget/defaultTextInput.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var appBarheight = 0.0;

  @override
  Widget build(BuildContext context) {
    appBarheight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 14, left: 14),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: appBarheight),
                    Card(
                      color: AppColor.backgroundColor,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: <Widget>[
                                Animator<Offset>(
                                  tween: Tween<Offset>(
                                    begin: Offset(0, 0.4),
                                    end: Offset(0, 0),
                                  ),
                                  duration: Duration(milliseconds: 700),
                                  cycles: 1,
                                  builder:
                                      (context, animate, _) => SlideTransition(
                                        position: animate.animation,
                                        child: Image.asset(
                                          AppData.splashBackground,
                                          fit: BoxFit.cover,
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 18,
                                    right: 18,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Sign Up',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.whiteColor,
                                                ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: Text(
                                              ' With',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    color: AppColor.whiteColor,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'email and phone',

                                            style: Theme.of(
                                              context,
                                            ).textTheme.headlineSmall!.copyWith(
                                              color: AppColor.whiteColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'number',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.headlineSmall!.copyWith(
                                              color: AppColor.whiteColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16),
                            child: Column(
                              children: <Widget>[
                                DefaultTextInput(
                                  hint: "Enter Email ID",
                                  onChange: (value) {},
                                  label: "Email ID",
                                  // validator: !state.isValidUsername,
                                  errorMsg: "Invalid email address",
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(15),
                                ),
                                DefaultTextInput(
                                  prefixText: "+27 ",
                                  hint: "Enter Number",
                                  onChange: (value) {},
                                  label: "Mobile Number",
                                  // validator: !state.isValidUsername,
                                  errorMsg: "Invalid Mobile Number",
                                ),

                                SizedBox(
                                  height: getProportionateScreenHeight(35),
                                ),

                                DefaultButton(
                                  text: 'SIGN UP',
                                  backgroundColor: AppColor.secondaryColor,
                                  borderColor: AppColor.secondaryColor,

                                  press: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => PhoneVerification(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Already have an account? ',
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(color: AppColor.blackText),
                        ),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            ' Sign In',
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge!.copyWith(
                              color: AppColor.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
