import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideAcceptedScreen extends StatefulWidget {
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final String rideType;
  final String pickupLocationTitle;
  final String pickupLocationAddress;
  final String dropLocationTitle;
  final String dropLocationAddress;
  final double estimatedFare;
  final String driverName;
  final String vehicleNumber;
  final String driverImageUrl;
  final double distanceToPickup;

  const RideAcceptedScreen({
    super.key,
    required this.pickupLatLng,
    required this.dropLatLng,
    required this.rideType,
    required this.pickupLocationTitle,
    required this.pickupLocationAddress,
    required this.dropLocationTitle,
    required this.dropLocationAddress,
    required this.estimatedFare,
    required this.driverName,
    required this.vehicleNumber,
    required this.driverImageUrl,
    required this.distanceToPickup,
  });

  @override
  State<RideAcceptedScreen> createState() => _RideAcceptedScreenState();
}

class _RideAcceptedScreenState extends State<RideAcceptedScreen> {
  late GoogleMapController _mapController;
  final Set<Polyline> _polyLines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setupMapElements();
  }

  void _setupMapElements() {
    // Add pickup marker
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: widget.pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    // Add drop marker
    _markers.add(
      Marker(
        markerId: const MarkerId('drop'),
        position: widget.dropLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Add route polyline
    _polyLines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [widget.pickupLatLng, widget.dropLatLng],
        color: Colors.blue,
        width: 4,
      ),
    );
  }

  void _showTripDetailsBottomSheet() {
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
                "Trip Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Driver info section
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(widget.driverImageUrl),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.driverName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.vehicleNumber,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Pickup & Drop locations
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 10, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(widget.pickupLocationTitle),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      widget.pickupLocationAddress,
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
                      Text(widget.dropLocationTitle),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      widget.dropLocationAddress,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Fare and distance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Estimated fare"),
                  Text("₹${widget.estimatedFare.toString()}"),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Distance to pickup"),
                  Text("${widget.distanceToPickup.toStringAsFixed(1)} km"),
                ],
              ),
              const SizedBox(height: 20),
              // Cancel button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
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
          // Map Section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.pickupLatLng,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                _mapController.animateCamera(
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

          // Driver Info Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Driver is on the way text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Captain on the way",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.textButtonColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Distance text
                          Text(
                            "${widget.distanceToPickup.toStringAsFixed(1)} km away",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "3 min",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    "Start your order with PIN",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  // Driver and vehicle info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person_rounded),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.driverName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.vehicleNumber,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.message),
                        onPressed: () {
                          // Implement message functionality
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Pickup location
                  const Text(
                    "Pickup From",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(widget.pickupLocationAddress)),
                      TextButton(
                        onPressed: _showTripDetailsBottomSheet,
                        child: const Text("Trip Details"),
                      ),
                    ],
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
