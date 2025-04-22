import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/view/account/notification.dart';
import 'package:fidelityride/view/authscreen/login.dart';
import 'package:fidelityride/view/authscreen/otpscreen.dart';
import 'package:fidelityride/view/authscreen/signup.dart';
import 'package:fidelityride/view/home/home.dart';
import 'package:fidelityride/view/home/mainScreen.dart';
import 'package:fidelityride/view/pickupdrop/pickupdropscreen.dart';
import 'package:fidelityride/view/splash/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RoutePath.auth:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case RoutePath.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case RoutePath.otpVerification:
        return MaterialPageRoute(builder: (_) => PhoneVerification());

      case RoutePath.homeScreen:
        return _buildPageTransition(
          const HomeScreen(),
          PageTransitionType.rightToLeft,
          500,
        );

      case RoutePath.searchScreen:
        return _buildPageTransition(
          const PickupDropScreen(),
          PageTransitionType.bottomToTop,
          500,
        );

      case RoutePath.mainScreen:
        return _buildPageTransition(
          const MainScreen(),
          PageTransitionType.fade,
          300,
        );

      case RoutePath.notification:
        return _buildPageTransition(
          const NotificationSettingsScreen(),
          PageTransitionType.fade,
          300,
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

  static PageTransition _buildPageTransition(
    Widget child,
    PageTransitionType type,
    int durationMs,
  ) {
    return PageTransition(
      child: child,
      type: type,
      duration: Duration(milliseconds: durationMs),
    );
  }
}

/*
older code
import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/view/account/notification.dart';
import 'package:fidelityride/view/authscreen/signup.dart';
import 'package:fidelityride/view/home/home.dart';
import 'package:fidelityride/view/home/mainScreen.dart';
import 'package:fidelityride/view/pickupdrop/pickupdropscreen.dart';
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
          duration: Duration(milliseconds: 500),
        );

      case RoutePath.searchScreen:
        return PageTransition(
          child: PickupDropScreen(),
          type: PageTransitionType.bottomToTop,
          duration: Duration(milliseconds: 500),
        );
      case RoutePath.mainScreen:
        return PageTransition(
          child: MainScreen(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 300),
        );
      case RoutePath.notification:
        return PageTransition(
          child: NotificationSettingsScreen(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 300),
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

 */
