import 'dart:async';

import 'package:fidelityride/constant.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/view/pickupdrop/ride_accepted_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' show Lottie;

import '../../mapservices/direction_service.dart';

class SearchingDriverScreen extends StatefulWidget {
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final String rideType;

  final String pickupLocationTitle;
  final String pickupLocationAddress;
  final String dropLocationTitle;
  final String dropLocationAddress;
  final double estimatedFare;

  const SearchingDriverScreen({
    super.key,
    required this.pickupLatLng,
    required this.dropLatLng,
    required this.rideType,
    required this.pickupLocationTitle,
    required this.pickupLocationAddress,
    required this.dropLocationTitle,
    required this.dropLocationAddress,
    required this.estimatedFare,
  });

  @override
  State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
}

class _SearchingDriverScreenState extends State<SearchingDriverScreen>
    with TickerProviderStateMixin {
  bool _rideAccepted = false;
  Timer? _searchingTimer;
  GoogleMapController? _mapController;
  final Set<Polyline> _polyLines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setupMapElements();
    _fetchPolyline(); // Now fetch actual route

    _searchingTimer = Timer(const Duration(seconds: 20), () {
      if (!mounted) return;
      setState(() => _rideAccepted = true);

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        _navigateToRideAccepted();
      });
    });
  }

  @override
  void dispose() {
    _searchingTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchPolyline() async {
    final directions = DirectionsRepository(apiKey: AppData.apiKey);
    try {
      final routePoints = await directions.getDirections(
        origin: widget.pickupLatLng,
        destination: widget.dropLatLng,
      );
      setState(() {
        _polyLines.clear();
        _polyLines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: routePoints,
            color: Colors.black,
            width: 4,
          ),
        );
      });
    } catch (e) {
      debugPrint("Failed to load route: $e");
    }
  }

  void _setupMapElements() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId('pickup'),
        position: widget.pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('drop'),
        position: widget.dropLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    ]);
  }

  void _navigateToRideAccepted() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => RideAcceptedScreen(
              pickupLatLng: widget.pickupLatLng,
              dropLatLng: widget.dropLatLng,
              rideType: widget.rideType,
              pickupLocationTitle: widget.pickupLocationTitle,
              pickupLocationAddress: widget.pickupLocationAddress,
              dropLocationTitle: widget.dropLocationTitle,
              dropLocationAddress: widget.dropLocationAddress,
              estimatedFare: widget.estimatedFare,
              driverName: "William ",
              vehicleNumber: "TN09DD6811",
              driverImageUrl: "https://example.com/driver.jpg",
              distanceToPickup: 1.1,
              googleApiKey: AppData.apiKey,
            ),
      ),
    );
  }

  void _showTripDetailsBottomSheet({
    required String pickupTitle,
    required String pickupAddress,
    required String dropTitle,
    required String dropAddress,
    required String totalFare,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Location Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // Pickup & Drop
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 10, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(pickupTitle),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      pickupAddress,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(dropTitle),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      dropAddress,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Fare
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total fare",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    totalFare,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close bottom sheet
                    Navigator.pop(context); // Go back (cancel ride)
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text("Cancel Ride"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Column(
        children: [
          // Top Map Half
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.pickupLatLng,
                zoom: 14,
              ),

              onMapCreated: (controller) {
                _mapController = controller;
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    LatLngBounds(
                      southwest: LatLng(
                        widget.pickupLatLng.latitude <=
                                widget.dropLatLng.latitude
                            ? widget.pickupLatLng.latitude
                            : widget.dropLatLng.latitude,
                        widget.pickupLatLng.longitude <=
                                widget.dropLatLng.longitude
                            ? widget.pickupLatLng.longitude
                            : widget.dropLatLng.longitude,
                      ),
                      northeast: LatLng(
                        widget.pickupLatLng.latitude >=
                                widget.dropLatLng.latitude
                            ? widget.pickupLatLng.latitude
                            : widget.dropLatLng.latitude,
                        widget.pickupLatLng.longitude >=
                                widget.dropLatLng.longitude
                            ? widget.pickupLatLng.longitude
                            : widget.dropLatLng.longitude,
                      ),
                    ),
                    100,
                  ),
                );
              },

              markers: _markers,
              polylines: _polyLines,

              zoomControlsEnabled: false,
              myLocationEnabled: true,
            ),
          ),

          // Bottom Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Looking for your\n${widget.rideType} ride",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          _showTripDetailsBottomSheet(
                            pickupTitle: widget.pickupLocationTitle,
                            pickupAddress: widget.pickupLocationAddress,
                            dropTitle: widget.dropLocationTitle,
                            dropAddress: widget.dropLocationAddress,
                            totalFare: "₹${widget.estimatedFare.toString()}",
                          );
                        },
                        child: const Text("Trip Details"),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Lottie.asset(
                      'assets/animation/loading.json',

                      // Replace with your file
                      repeat: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
