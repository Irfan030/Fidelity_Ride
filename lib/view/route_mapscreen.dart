import 'package:flutter/material.dart';

import 'booking_success.dart';

class RouteMapScreen extends StatelessWidget {
  final String pickup;
  final String drop;

  RouteMapScreen({required this.pickup, required this.drop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Route Map")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pickup: $pickup"),
            Text("Drop: $drop"),
            SizedBox(height: 20),
            Text("Distance: ~12 km"), // mock value
            SizedBox(height: 40),
            ElevatedButton(
              child: Text("Confirm Booking"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BookingSuccessScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
