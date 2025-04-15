import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/view/pickupdrop/searching_driver.dart';
import 'package:fidelityride/widget/defaultButton.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'get_location_map.dart';

class ConfirmPickupScreen extends StatefulWidget {
  final String initialAddress;
  final double initialLatitude;
  final double initialLongitude;

  final String dropAddress; // NEW
  final double dropLatitude; // NEW
  final double dropLongitude; // NEW
  final String selectedRideType;

  const ConfirmPickupScreen({
    super.key,
    required this.initialAddress,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.dropAddress, // NEW
    required this.dropLatitude, // NEW
    required this.dropLongitude, // NEW
    required this.selectedRideType, // ✅ Add this
  });

  @override
  State<ConfirmPickupScreen> createState() => _ConfirmPickupScreenState();
}

class _ConfirmPickupScreenState extends State<ConfirmPickupScreen> {
  GoogleMapController? _mapController;
  late LatLng _pickupLatLng;
  late String _pickupAddress;
  late LatLng _dropLatLng;
  late String _dropAddress;

  @override
  void initState() {
    super.initState();
    _pickupLatLng = LatLng(widget.initialLatitude, widget.initialLongitude);
    _pickupAddress = widget.initialAddress;

    _dropLatLng = LatLng(widget.dropLatitude, widget.dropLongitude); // NEW
    _dropAddress = widget.dropAddress; // NEW
  }

  Future<void> _changePickupLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapLocationPickerScreen(title: "Pickup Location"),
      ),
    );

    if (result != null && result is Map) {
      setState(() {
        _pickupAddress = result['address'];
        _pickupLatLng = LatLng(result['latitude'], result['longitude']);
        _mapController?.animateCamera(CameraUpdate.newLatLng(_pickupLatLng));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🗺️ Map with pickup location
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickupLatLng,
              zoom: 16,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('pickup'),
                position: _pickupLatLng,
                infoWindow: const InfoWindow(title: "Pickup Point"),
              ),
            },
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          /// 📍 Pickup info container
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Check your pickup point",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Select a nearby point for easier pickup",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  /// 📦 Address box (with tap to change)
                  GestureDetector(
                    onTap: _changePickupLocation,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.mainColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _pickupAddress,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.edit, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// 🚕 Confirm Pickup
                  SizedBox(
                    width: double.infinity,
                    child: DefaultButton(
                      text: "Confirm Pickup",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => SearchingDriverScreen(
                                  pickupLatLng: _pickupLatLng,
                                  dropLatLng: _dropLatLng,
                                  rideType: widget.selectedRideType,
                                  pickupLocationTitle:
                                      "Pickup Point", // or extract from address
                                  pickupLocationAddress: _pickupAddress,
                                  dropLocationTitle:
                                      "Drop Point", // or extract from address
                                  dropLocationAddress: widget.dropAddress,
                                  estimatedFare: _calculateFare(
                                    widget
                                        .selectedRideType, // pass your calculated fare here                                ),
                                  ),
                                ),
                          ),
                        );
                      },
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

  double _calculateFare(String rideType) {
    switch (rideType) {
      case 'Bike':
        return 50.0;
      case 'Auto':
        return 80.0;
      case 'Cab Economy':
        return 120.0;
      case 'Cab Premium':
        return 180.0;
      default:
        return 100.0;
    }
  }
}
