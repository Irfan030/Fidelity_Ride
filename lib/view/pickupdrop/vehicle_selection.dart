import 'dart:math';

import 'package:fidelityride/constant.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../mapservices/direction_service.dart';
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
      price: 'R 150',
      isFastest: true,
      maxPassengers: 1,
    ),
    RideOption(
      type: 'Standard Cab',
      icon: Icons.local_taxi,
      description: 'Quick Standard Cab rides',
      time: '4 mins',
      dropTime: 'Drop 1:21 am',
      price: 'R 200',
      maxPassengers: 3,
    ),
    RideOption(
      type: 'Armored Cab',
      icon: Icons.security,
      description: 'Secure rides',
      time: '2 mins',
      dropTime: 'Drop 1:19 am',
      price: 'R 300',
      maxPassengers: 4,
    ),
    RideOption(
      type: 'XL Cab',
      icon: Icons.airport_shuttle,
      description: 'Comfortable rides',
      time: '2 mins',
      dropTime: 'Drop 1:19 am',
      price: 'R 250',
      maxPassengers: 4,
    ),
  ];

  // Add these new properties
  bool _isLoadingRoute = true;
  bool _routeError = false;
  late final DirectionsRepository _directionsRepository;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _directionsRepository = DirectionsRepository(apiKey: AppData.apiKey);
    _initializeMap();
  }

  @override
  void dispose() {
    _directionsRepository.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      // Add markers first for immediate visibility
      _addMarkers();

      // Load route asynchronously
      await _loadRoute();
    } catch (e) {
      setState(() {
        _routeError = true;
        _isLoadingRoute = false;
      });
    }
  }

  void _addMarkers() {
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
    setState(() {});
  }

  Future<void> _loadRoute() async {
    try {
      final points = await _directionsRepository.getDirections(
        origin: widget.pickupLatLng,
        destination: widget.dropLatLng,
      );

      // Simplify the polyline for long routes to improve performance
      final optimizedPoints =
          points.length > 100
              ? _simplifyPolyline(points, tolerance: 0.0001)
              : points;

      _polyLines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: optimizedPoints,
          width: 4,
          geodesic: true,
        ),
      );

      // Zoom to fit the route
      _zoomToRoute(optimizedPoints);
    } catch (e) {
      _polyLines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [widget.pickupLatLng, widget.dropLatLng],
          color: Colors.black,
          width: 4,
        ),
      );
      rethrow;
    } finally {
      setState(() => _isLoadingRoute = false);
    }
  }

  void _zoomToRoute(List<LatLng> points) {
    final bounds = _boundsFromLatLngList(points);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    });
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (final latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        x0 = min(x0, latLng.latitude);
        x1 = max(x1!, latLng.latitude);
        y0 = min(y0!, latLng.longitude);
        y1 = max(y1!, latLng.longitude);
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  List<LatLng> _simplifyPolyline(
    List<LatLng> points, {
    double tolerance = 0.0001,
  }) {
    if (points.length <= 2) return points;

    final simplified = [points.first];
    for (int i = 1; i < points.length - 1; i++) {
      final distance = _pointToLineDistance(
        points[i],
        simplified.last,
        points.last,
      );
      if (distance > tolerance) {
        simplified.add(points[i]);
      }
    }
    simplified.add(points.last);
    return simplified;
  }

  double _pointToLineDistance(LatLng point, LatLng start, LatLng end) {
    if (start == end) {
      return sqrt(
        pow(point.latitude - start.latitude, 2) +
            pow(point.longitude - start.longitude, 2),
      );
    }

    final d =
        pow(end.latitude - start.latitude, 2) +
        pow(end.longitude - start.longitude, 2);
    final t =
        ((point.latitude - start.latitude) * (end.latitude - start.latitude) +
            (point.longitude - start.longitude) *
                (end.longitude - start.longitude)) /
        d;

    if (t < 0) {
      return sqrt(
        pow(point.latitude - start.latitude, 2) +
            pow(point.longitude - start.longitude, 2),
      );
    } else if (t > 1) {
      return sqrt(
        pow(point.latitude - end.latitude, 2) +
            pow(point.longitude - end.longitude, 2),
      );
    }

    return sqrt(
      pow(
            point.latitude -
                (start.latitude + t * (end.latitude - start.latitude)),
            2,
          ) +
          pow(
            point.longitude -
                (start.longitude + t * (end.longitude - start.longitude)),
            2,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Add this line

      key: _scaffoldKey,

      backgroundColor: AppColor.backgroundColor,
      body: Column(
        children: [
          // Map View with loading indicator
          SizedBox(
            height: SizeConfig.screenHeight * 0.5,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.pickupLatLng,
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (!_isLoadingRoute && !_routeError) {
                      _zoomToRoute(_polyLines.first.points);
                    }
                  },
                  markers: _markers,
                  polylines: _polyLines,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                ),
                if (_isLoadingRoute)
                  const Center(child: CircularProgressIndicator()),
                if (_routeError)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.red.withOpacity(0.7),
                      child: const Text(
                        'Failed to load route details',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Ride options list with memoization
          Expanded(
            child: _RideOptionsList(
              options: _rideOptions,
              selectedIndex: _selectedOptionIndex,
              onSelected:
                  (index) => setState(() => _selectedOptionIndex = index),
            ),
          ),

          // Payment and booking section
          SafeArea(
            top: false,

            child: _BottomBookingSection(
              paymentMethod: _selectedPaymentMethod,
              onPaymentPressed: () => _showPaymentBottomSheet(context),
              bookingEnabled: _selectedOptionIndex != null,
              bookingText:
                  _selectedOptionIndex != null
                      ? 'Book ${_rideOptions[_selectedOptionIndex!].type}'
                      : 'Select a ride',
              onBookingPressed:
                  _selectedOptionIndex != null
                      ? () => _navigateToConfirmation()
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToConfirmation() {
    final selectedOption = _rideOptions[_selectedOptionIndex!];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ConfirmPickupScreen(
              initialAddress: widget.pickupLocation,
              initialLatitude: widget.pickupLatLng.latitude,
              initialLongitude: widget.pickupLatLng.longitude,
              dropAddress: widget.dropLocation,
              dropLatitude: widget.dropLatLng.latitude,
              dropLongitude: widget.dropLatLng.longitude,
              selectedRideType: selectedOption.type,
            ),
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

class _RideOptionsList extends StatelessWidget {
  final List<RideOption> options;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  const _RideOptionsList({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.whiteColor,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: options.length,
        itemBuilder: (context, index) {
          return _RideOptionItem(
            option: options[index],
            isSelected: selectedIndex == index,
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}

class _RideOptionItem extends StatelessWidget {
  final RideOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _RideOptionItem({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey[100],
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
}

class _BottomBookingSection extends StatelessWidget {
  final String paymentMethod;
  final VoidCallback onPaymentPressed;
  final bool bookingEnabled;
  final String bookingText;
  final VoidCallback? onBookingPressed;

  const _BottomBookingSection({
    required this.paymentMethod,
    required this.onPaymentPressed,
    required this.bookingEnabled,
    required this.bookingText,
    this.onBookingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: InkWell(
            onTap: onPaymentPressed,
            child: Row(
              children: [
                Text(paymentMethod, style: const TextStyle(fontSize: 18)),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: ElevatedButton(
            onPressed: onBookingPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(bookingText, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }
}
