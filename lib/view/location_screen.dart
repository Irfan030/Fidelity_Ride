import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LatLng selectedLocation = LatLng(37.7749, -122.4194);

    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: selectedLocation,
          zoom: 14,
        ),
        onTap: (latLng) {
          Navigator.pop(
            context,
            "Lat: ${latLng.latitude}, Lng: ${latLng.longitude}",
          );
        },
      ),
    );
  }
}
