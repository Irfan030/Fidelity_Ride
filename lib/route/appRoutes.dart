import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/view/authscreen/signup.dart';
import 'package:fidelityride/view/fairestimation/fare_estimation_screen.dart';
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
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 500),
        );

      case RoutePath.fareEstimate:
        return PageTransition(
          child: FareEstimateScreen(),
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 500),
        );
      //
      // case RoutePath.rideConfirm:
      //   return PageTransition(
      //     child: RideConfirmScreen(),
      //     type: PageTransitionType.rightToLeft,
      //     duration: Duration(milliseconds: 500),
      //   );
      //
      // case RoutePath.searchingDriver:
      //   return PageTransition(
      //     child: SearchingDriverScreen(),
      //     type: PageTransitionType.fade,
      //     duration: Duration(milliseconds: 500),
      //   );
      //
      // case RoutePath.rideAccepted:
      //   return PageTransition(
      //     child: RideAcceptedScreen(),
      //     type: PageTransitionType.rightToLeft,
      //     duration: Duration(milliseconds: 500),
      //   );
      //
      // case RoutePath.rideInProgress:
      //   return PageTransition(
      //     child: RideInProgressScreen(),
      //     type: PageTransitionType.rightToLeft,
      //     duration: Duration(milliseconds: 500),
      //   );
      //
      // case RoutePath.rideCompleted:
      //   return PageTransition(
      //     child: RideCompletedScreen(),
      //     type: PageTransitionType.rightToLeft,
      //     duration: Duration(milliseconds: 500),
      //   );

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
