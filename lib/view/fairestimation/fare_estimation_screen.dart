import 'package:fidelityride/route/routePath.dart';
import 'package:flutter/material.dart';

class FareEstimateScreen extends StatelessWidget {
  const FareEstimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Safe access to arguments to avoid type error
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};

    // ✅ Fallback values to avoid null errors
    final pickup = args['pickup'] ?? 'Not set';
    final drop = args['drop'] ?? 'Not set';
    final cabType = args['cabType'] ?? 'Standard Cab';
    final fare = args['fare'] ?? 0;
    final eta = args['eta'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: const Text('Fare Estimate')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pickup: $pickup"),
            Text("Drop: $drop"),
            const SizedBox(height: 16),
            Text("Cab Type: $cabType"),
            Text("Estimated Fare: \$$fare"),
            Text("ETA: $eta"),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutePath.rideConfirm);
              },
              child: const Text("Confirm Booking"),
            ),
          ],
        ),
      ),
    );
  }
}
