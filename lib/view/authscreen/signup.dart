import 'package:animator/animator.dart';
import 'package:fidelityride/constant.dart';
import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/theme/sizeConfig.dart';
import 'package:fidelityride/widget/authHeader.dart';
import 'package:fidelityride/widget/defaultButton.dart';
import 'package:fidelityride/widget/defaultTextInput.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  var appBarHeight = 0.0;
  final _formKey = GlobalKey<FormState>();
  String email = "", phone = "";

  @override
  Widget build(BuildContext context) {
    appBarHeight =
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
                    SizedBox(height: appBarHeight),
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
                              color: AppColor.mainColor,
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
                                BuildHeaderText(),
                              ],
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  DefaultTextInput(
                                    hint: "Enter Email ID",
                                    label: "Email ID",
                                    onChange: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    },
                                    validator: AppData.isInvalidEmail(email),
                                    errorMsg: "Invalid email id ",
                                  ),

                                  SizedBox(
                                    height: getProportionateScreenHeight(15),
                                  ),
                                  DefaultTextInput(
                                    prefixText: "+27 ",
                                    hint: "Enter Number",
                                    label: "Mobile Number",
                                    onChange: (value) {
                                      setState(() {
                                        phone = value;
                                      });
                                    },
                                    validator: AppData.isInvalidPhoneNo(phone),
                                    errorMsg: "Invalid Mobile Number",
                                  ),

                                  SizedBox(
                                    height: getProportionateScreenHeight(35),
                                  ),

                                  DefaultButton(
                                    text: 'SIGN UP',
                                    backgroundColor: AppColor.mainColor,
                                    borderColor: AppColor.mainColor,

                                    press: () {
                                      if (_formKey.currentState!.validate()) {
                                        Navigator.pushNamed(
                                          context,
                                          RoutePath.otpVerification,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
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
                            Navigator.pushNamed(context, RoutePath.login);
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
