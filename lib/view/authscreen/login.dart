import 'package:animator/animator.dart';
import 'package:fidelityride/constant.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/view/authscreen/otpscreen.dart';
import 'package:fidelityride/widget/defaultTextInput.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              color: AppColor.secondaryColor,
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
                            color: AppColor.secondaryColor,
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 18,
                            right: 18,
                          ),
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
                                onChange: (value) {},
                                label: "Mobile Number",
                                // validator: !state.isValidUsername,
                                errorMsg: "Invalid Mobile Number",
                              ),
                              // Container(
                              //   height: 50,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.all(
                              //       Radius.circular(10),
                              //     ),
                              //     border: Border.all(
                              //       color: Theme.of(context).dividerColor,
                              //     ),
                              //     color: Theme.of(context).colorScheme.surface,
                              //   ),
                              //   child: Row(
                              //     children: <Widget>[
                              //       SizedBox(
                              //         width: 86,
                              //         child: SizedBox(
                              //           width: 80,
                              //           height: 60,
                              //           child: Center(
                              //             child: CountryPickerDropdown(
                              //               initialValue:
                              //                   'ZA', // ISO code for South Africa
                              //               onTap:
                              //                   () => FocusScope.of(
                              //                     context,
                              //                   ).requestFocus(FocusNode()),
                              //               onValuePicked: (Country country) {},
                              //               itemBuilder: (Country country) {
                              //                 return Padding(
                              //                   padding:
                              //                       const EdgeInsets.symmetric(
                              //                         horizontal: 8.0,
                              //                       ),
                              //                   child: Row(
                              //                     children: <Widget>[
                              //                       SizedBox(
                              //                         height: 25,
                              //                         width: 25,
                              //                         child:
                              //                             CountryPickerUtils.getDefaultFlagImage(
                              //                               country,
                              //                             ),
                              //                       ),
                              //                       const SizedBox(width: 8.0),
                              //                       Text(
                              //                         '+${country.phoneCode}',
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 );
                              //               },
                              //               itemHeight: null,
                              //               isExpanded: true,
                              //               icon: SizedBox(),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       Expanded(
                              //         child: TextFormField(
                              //           style: Theme.of(
                              //             context,
                              //           ).textTheme.bodyMedium!.copyWith(
                              //             color:
                              //                 Theme.of(
                              //                   context,
                              //                 ).textTheme.titleLarge!.color,
                              //           ),
                              //           keyboardType: TextInputType.number,
                              //           decoration: InputDecoration(
                              //             contentPadding: EdgeInsets.only(
                              //               bottom: 8,
                              //             ),
                              //             hintText: 'Mobile Number',
                              //
                              //             hintStyle: Theme.of(
                              //               context,
                              //             ).textTheme.bodyMedium!.copyWith(
                              //               color:
                              //                   Theme.of(context).dividerColor,
                              //             ),
                              //             border: InputBorder.none,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(height: 20),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PhoneVerification(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColor.secondaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'NEXT',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(
                                              context,
                                            ).scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
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
