import 'package:animator/animator.dart';
import 'package:fidelityride/constant.dart';
import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/widget/defaultButton.dart';
import 'package:fidelityride/widget/defaultTextInput.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/authController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();
  String phone = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: 220,
              color: AppColor.mainColor,
              child: Animator<Offset>(
                tween: Tween<Offset>(begin: Offset(0, 0.4), end: Offset(0, 0)),
                duration: Duration(seconds: 1),
                cycles: 1,
                builder:
                    (context, animate, _) => SlideTransition(
                      position: animate.animation,
                      child: Image.asset(
                        AppData.splashBackground,
                        fit: BoxFit.fill,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Expanded(flex: 1, child: SizedBox()),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColor.backgroundColor,
                          border: Border.all(
                            color: AppColor.mainColor,
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 18,
                            right: 18,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Login',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge!.color,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        ' With Your',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.headlineSmall!.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleLarge!.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'phone number',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge!.color,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                DefaultTextInput(
                                  prefixText: "+27 ",
                                  hint: "Enter Number",
                                  keyboardType: TextInputType.number,
                                  label: "Mobile Number",
                                  onChange: (value) {
                                    setState(() {
                                      controller.phone = value;
                                    });
                                  },
                                  validator: AppData.isInvalidPhoneNo(phone),
                                  errorMsg: "Invalid Mobile Number",
                                ),

                                SizedBox(height: 20),
                                DefaultButton(
                                  text: 'NEXT',
                                  backgroundColor: AppColor.mainColor,
                                  borderColor: AppColor.mainColor,

                                  press: () {
                                    controller.login();
                                    /* if (_formKey.currentState!.validate()) {
                                      Navigator.pushNamed(
                                        context,
                                        RoutePath.otpVerification,
                                      );
                                    } */
                                  },
                                ),

                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 3, child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
