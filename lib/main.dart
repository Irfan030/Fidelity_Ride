import 'package:fidelityride/route/appRoutes.dart';
import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/theme/sizeConfig.dart';
import 'package:flutter/material.dart';

import 'constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      title: AppData.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePath.splash,
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
