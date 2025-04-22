import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';

class BuildHeaderText extends StatelessWidget {
  const BuildHeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Sign Up',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.whiteColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  ' With',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'email and phone',

                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.copyWith(color: AppColor.whiteColor),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'number',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.copyWith(color: AppColor.whiteColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
