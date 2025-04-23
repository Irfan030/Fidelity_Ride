import 'package:fidelityride/constant.dart';
import 'package:fidelityride/mapservices/google_place_api.dart';
import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/theme/sizeConfig.dart';
import 'package:fidelityride/view/pickupdrop/vehicle_selection.dart';
import 'package:fidelityride/widget/titleWidget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String pickupLocation = "Current Location";
  List<String> recentDrops = [];
  bool isLoadingRecentDrops = true;

  @override
  void initState() {
    super.initState();
    _setPickupLocation();
    _loadRecentDropLocations(); // <-- Load recent drops on init
  }

  void _setPickupLocation() async {
    Position? position = await _getCurrentLocation(context);
    if (position != null) {
      String address = await _getAddressFromLatLng(position);
      setState(() {
        pickupLocation = address;
      });
    } else {
      setState(() {
        pickupLocation = "Unable to fetch location";
      });
    }
  }

  void _loadRecentDropLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final drops = prefs.getStringList('recent_drops') ?? [];
    setState(() {
      recentDrops = drops;
      isLoadingRecentDrops = false;
    });
  }

  Future<List<String>> _getRecentDropLocations() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('recent_drops') ?? [];
  }

  // Function to get current location
  Future<Position?> _getCurrentLocation(BuildContext context) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        return null;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Location Permission Denied"),
                content: const Text(
                  "Please enable location permissions in app settings.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Geolocator.openAppSettings(),
                    child: const Text("Open Settings"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
        );
        return null;
      }

      // Get the current position
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.name}, ${place.locality}, ${place.country}";
      }
      return "Unknown location";
    } catch (e) {
      print("Error getting address: $e");
      return "Unknown location";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              AppData.appicon,
              width: SizeConfig.screenWidth / 2,
              fit: BoxFit.contain,
            ),
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColor.mainColor,
              ),
              onPressed:
                  () => Navigator.of(context).pushNamed(RoutePath.notification),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //search bar
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutePath.searchScreen);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColor.blackText),
                            const SizedBox(width: 8),
                            TitleWidget(
                              val: "Where to ?",
                              fontSize: 16,
                              letterSpacing: 0,
                              fontFamily: AppData.poppinsMedium,
                              color: AppColor.blackText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: getProportionateScreenHeight(16)),

              //recent search location
              // FutureBuilder<List<String>>(
              //   future: _getRecentDropLocations(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const CircularProgressIndicator();
              //     }
              //
              //     if (snapshot.hasError ||
              //         !snapshot.hasData ||
              //         snapshot.data!.isEmpty) {
              //       return Container(); // Return empty container if no recent locations
              //     }
              //
              //     final recentDrops = snapshot.data!;
              //     return Column(
              //       children: [
              //         for (final dropLocation in recentDrops.take(
              //           2,
              //         )) // Show max 2 recent locations
              //           Column(
              //             children: [
              //               _recentLocation(
              //                 context,
              //                 dropLocation.split(',').first.trim(), // Title
              //                 dropLocation
              //                     .split(',')
              //                     .skip(1)
              //                     .join(',')
              //                     .trim(), // Subtitle
              //                 dropLocation, // Full address for drop
              //               ),
              //               const SizedBox(height: 10),
              //             ],
              //           ),
              //       ],
              //     );
              //   },
              // ),

              //blinking issue

              // Recent locations
              if (isLoadingRecentDrops)
                const CircularProgressIndicator()
              else if (recentDrops.isNotEmpty)
                Column(
                  children: [
                    for (final dropLocation in recentDrops.take(2))
                      Column(
                        children: [
                          _recentLocation(
                            context,
                            dropLocation.split(',').first.trim(),
                            dropLocation.split(',').skip(1).join(',').trim(),
                            dropLocation,
                          ),
                        ],
                      ),
                  ],
                ),
              SizedBox(height: getProportionateScreenHeight(16)),

              //suggestion
              TitleWidget(
                val: "Suggestion",
                fontSize: 20,
                letterSpacing: 0,
                fontFamily: AppData.openSansBold,
                color: AppColor.blackText,
              ),

              SizedBox(height: getProportionateScreenHeight(12)),

              SizedBox(
                height: getProportionateScreenHeight(100),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTypeCard(
                      context,
                      'Bike',
                      'assets/images/bike_icon.png',
                      Colors.white,
                      RoutePath.searchScreen,
                    ),
                    _buildTypeCard(
                      context,
                      'Cab',
                      'assets/images/car_icon.png',
                      Colors.white,
                      RoutePath.searchScreen,
                    ),
                    _buildTypeCard(
                      context,
                      'Armored',
                      'assets/images/armored_icon.png',
                      Colors.white,
                      RoutePath.searchScreen,
                    ),
                    _buildTypeCard(
                      context,
                      'XL Cab',
                      'assets/images/xl_car_icon.png',
                      Colors.white,
                      RoutePath.searchScreen,
                    ),
                    _buildTypeCard(
                      context,
                      'Armored XL',
                      'assets/images/armored_icon.png',
                      Colors.white,
                      RoutePath.searchScreen,
                    ),
                  ],
                ),
              ),

              SizedBox(height: getProportionateScreenHeight(16)),

              _buildFeatureHighlights(),
              SizedBox(height: getProportionateScreenHeight(16)),

              SizedBox(
                height: getProportionateScreenHeight(140),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _promoBanner(
                      'Book now ',
                      'assets/images/car.png',
                      context,
                      RoutePath.searchScreen,
                    ),
                    _promoBanner(
                      'Book now',
                      'assets/images/armored_car.png',
                      context,
                      RoutePath.searchScreen,
                    ),
                  ],
                ),
              ),

              SizedBox(height: getProportionateScreenHeight(16)),

              // Add the SecureDrive banner at the top
              // _buildSecureDriveBanner(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentLocation(
    BuildContext context,
    String title,
    String subtitle,
    String dropLocation,
  ) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );
        Position? currentPosition = await _getCurrentLocation(context);

        Navigator.of(context).pop();

        if (currentPosition != null) {
          // Get place details to extract coordinates
          final placeDetails = await GooglePlaceService().fetchPlaceDetails(
            dropLocation,
          );

          if (placeDetails != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => RideOptionsScreen(
                      pickupLocation: pickupLocation,
                      dropLocation: dropLocation,
                      pickupLatLng: LatLng(
                        currentPosition.latitude,
                        currentPosition.longitude,
                      ),
                      dropLatLng: LatLng(
                        placeDetails['latitude'],
                        placeDetails['longitude'],
                      ),
                    ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Could not get location details.")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Could not get current location. Please enable location services.",
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.history, color: AppColor.blackText),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWidget(
                    val: title,
                    fontSize: 16,
                    letterSpacing: 0,
                    fontFamily: AppData.poppinsMedium,
                    color: AppColor.blackText,
                  ),
                  TitleWidget(
                    val: subtitle,
                    fontSize: 14,
                    letterSpacing: 0,
                    fontFamily: AppData.poppinsRegular,
                    color: AppColor.greyText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(
    BuildContext context,
    String label,
    String imageAsset,
    Color bgColor,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: AppColor.greyText, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                imageAsset,
                width: getProportionateScreenHeight(50),
                height: getProportionateScreenHeight(50),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _promoBanner(
    String title,
    String asset,
    BuildContext context,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),

      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          val: "Features",
          fontSize: 20,
          letterSpacing: 0,
          fontFamily: AppData.openSansBold,
          color: AppColor.blackText,
        ),
        SizedBox(height: getProportionateScreenHeight(12)),
        SizedBox(
          height: getProportionateScreenHeight(160),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFeatureCard(
                Icons.gps_fixed,
                'Live Tracking',
                'Real-time tracking with speed, distance, and fuel data',
              ),
              _buildFeatureCard(
                Icons.security,
                'Theft Prevention',
                'AI-powered tamper detection with instant alerts',
              ),

              _buildFeatureCard(
                Icons.verified_user,
                'Verified Drivers',
                'All drivers are background-checked and verified for your safety',
              ),

              _buildFeatureCard(
                Icons.warning,
                'Emergency SOS',
                'Instant SOS button to alert emergency contacts and authorities',
              ),
              _buildFeatureCard(
                Icons.payment,
                'Secure Payments',
                'Encrypted and hassle-free payment methods including in-app options',
              ),
              _buildFeatureCard(
                Icons.schedule,
                'Ride Scheduling',
                'Book cabs in advance for planned travel with timely reminders',
              ),
              _buildFeatureCard(
                Icons.privacy_tip,
                'Privacy Protection',
                'Your data is encrypted and never shared without your consent',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      width: getProportionateScreenWidth(150),
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColor.greyText, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.mainColor, size: 30),
          const SizedBox(height: 10),
          TitleWidget(
            val: title,
            fontSize: 12,
            letterSpacing: 0,
            fontFamily: AppData.openSansBold,
            color: AppColor.blackText,
          ),

          const SizedBox(height: 6),
          Expanded(
            child: Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
