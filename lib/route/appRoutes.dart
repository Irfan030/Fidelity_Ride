import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/view/authscreen/signup.dart';
import 'package:fidelityride/view/home/home.dart';
import 'package:fidelityride/view/home/mainScreen.dart';
import 'package:fidelityride/view/splash/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RoutePath.auth:
        return MaterialPageRoute(builder: (_) => SignUpScreen());

      case RoutePath.homeScreen:
        return PageTransition(
          child: HomeScreen(),
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 0),
        );

      case RoutePath.mainScreen:
        return PageTransition(
          child: MainScreen(),
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 0),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
