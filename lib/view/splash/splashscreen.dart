import 'package:fidelityride/constant.dart';
import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOutBack,
    );

    _controller!.forward().whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, RoutePath.auth);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
            (_animation != null)
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _animation!,
                      child: FadeTransition(
                        opacity: _animation!,
                        child: Image.asset(
                          AppData.appicon,
                          width: 220,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.secondaryColor,
                      ),
                    ),
                  ],
                )
                : const SizedBox.shrink(),
      ),
    );
  }
}
