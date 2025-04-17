import 'dart:math';

import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../theme/sizeConfig.dart';
import 'confirm_pickup.dart';

class RideOptionsScreen extends StatefulWidget {
  final String pickupLocation;
  final String dropLocation;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;

  const RideOptionsScreen({
    super.key,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupLatLng,
    required this.dropLatLng,
  });

  @override
  State<RideOptionsScreen> createState() => _RideOptionsScreenState();
}

class _RideOptionsScreenState extends State<RideOptionsScreen> {
  int? _selectedOptionIndex;
  String _selectedPaymentMethod = 'Cash';

  late GoogleMapController _mapController;
  final Set<Polyline> _polyLines = {};
  final Set<Marker> _markers = {};

  final List<RideOption> _rideOptions = [
    RideOption(
      type: 'Bike',
      icon: Icons.directions_bike,
      description: 'Quick Bike rides',
      time: '2 mins away',
      dropTime: 'Drop 1:18 am',
      price: '₹150',
      isFastest: true,
      maxPassengers: 1,
    ),
    RideOption(
      type: 'Standard Cab',
      icon: Icons.local_taxi,
      description: 'Quick Standard Cab rides',
      time: '4 mins',
      dropTime: 'Drop 1:21 am',
      price: '₹200',
      maxPassengers: 3,
    ),
    RideOption(
      type: 'Armored Cab',
      icon: Icons.security,
      description: 'Secure rides',
      time: '2 mins',
      dropTime: 'Drop 1:19 am',
      price: '₹300',
      maxPassengers: 4,
    ),
    RideOption(
      type: 'XL Cab',
      icon: Icons.airport_shuttle,
      description: 'Comfortable rides',
      time: '2 mins',
      dropTime: 'Drop 1:19 am',
      price: '₹250',
      maxPassengers: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupMap();
  }

  void _setupMap() {
    // Add markers
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: widget.pickupLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('drop'),
        position: widget.dropLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    // Add polyline
    _polyLines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [widget.pickupLatLng, widget.dropLatLng],
        color: Colors.black,
        width: 4,
      ),
    );
  }

  void _showPaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColor.backgroundColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildPaymentOption(
                      "Fidelity Wallet",
                      false,
                      setModalState,
                    ),
                    _buildPaymentOption("AmazonPay", false, setModalState),
                    _buildPaymentOption("GPay", false, setModalState),
                    _buildPaymentOption("Pay at drop", false, setModalState),
                    _buildPaymentOption("Cash", true, setModalState),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildPaymentOption(
    String method,
    bool isDefaultEnabled,
    Function(void Function()) setModalState,
  ) {
    return ListTile(
      leading: Icon(
        method == "Cash" ? Icons.money : Icons.account_balance_wallet,
        color: AppColor.secondaryColor,
      ),
      title: Text(method),
      trailing: Radio<String>(
        value: method,
        groupValue: _selectedPaymentMethod,
        onChanged: (value) {
          setModalState(() {
            _selectedPaymentMethod = value!;
          });
          setState(() {
            _selectedPaymentMethod = value!;
          });
          Navigator.pop(context); // close the bottom sheet
        },
      ),
    );
  }

  Widget _buildRideOption(BuildContext context, RideOption option, int index) {
    final isSelected = _selectedOptionIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOptionIndex = index;
        });
      },
      child: Card(
        color: AppColor.whiteColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side:
              isSelected
                  ? BorderSide(color: AppColor.mainColor, width: 1)
                  : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(option.icon, size: 40, color: AppColor.secondaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          option.type,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (option.isFastest) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "FASTEST",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      option.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.time,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    option.price,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    option.dropTime,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${option.maxPassengers}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Column(
        children: [
          // Map View
          SizedBox(
            height: SizeConfig.screenHeight * 0.5,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.pickupLatLng,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                // Zoom to fit both markers
                _mapController.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    LatLngBounds(
                      southwest: LatLng(
                        min(
                          widget.pickupLatLng.latitude,
                          widget.dropLatLng.latitude,
                        ),
                        min(
                          widget.pickupLatLng.longitude,
                          widget.dropLatLng.longitude,
                        ),
                      ),
                      northeast: LatLng(
                        max(
                          widget.pickupLatLng.latitude,
                          widget.dropLatLng.latitude,
                        ),
                        max(
                          widget.pickupLatLng.longitude,
                          widget.dropLatLng.longitude,
                        ),
                      ),
                    ),
                    100, // padding
                  ),
                );
              },
              markers: _markers,
              polylines: _polyLines,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),

          Expanded(
            child: Container(
              color: AppColor.whiteColor,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _rideOptions.length,
                itemBuilder: (context, index) {
                  final option = _rideOptions[index];
                  return _buildRideOption(context, option, index);
                },
              ),
            ),
          ),

          // Bottom button
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () => _showPaymentBottomSheet(context),
              child: Row(
                children: [
                  Icon(Icons.money, color: AppColor.secondaryColor),
                  const SizedBox(width: 8),
                  Text(
                    _selectedPaymentMethod,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: ElevatedButton(
              onPressed:
                  _selectedOptionIndex != null
                      ? () {
                        final selectedOption =
                            _rideOptions[_selectedOptionIndex!];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ConfirmPickupScreen(
                                  initialAddress:
                                      widget.pickupLocation, // just the string
                                  initialLatitude: widget.pickupLatLng.latitude,
                                  initialLongitude:
                                      widget.pickupLatLng.longitude,

                                  dropAddress: widget.dropLocation, // ✅ added
                                  dropLatitude:
                                      widget.dropLatLng.latitude, // ✅ added
                                  dropLongitude: widget.dropLatLng.longitude,
                                  selectedRideType: selectedOption.type,
                                ),
                          ),
                        );
                      }
                      : null,

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.mainColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                _selectedOptionIndex != null
                    ? 'Book ${_rideOptions[_selectedOptionIndex!].type}'
                    : 'Select a ride',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RideOption {
  final String type;
  final IconData icon;
  final String description;
  final String time;
  final String dropTime;
  final String price;
  final bool isFastest;
  final int maxPassengers;

  RideOption({
    required this.type,
    required this.icon,
    required this.description,
    required this.time,
    required this.dropTime,
    required this.price,
    this.isFastest = false,
    required this.maxPassengers,
  });
}
