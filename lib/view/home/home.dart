import 'package:fidelityride/constant.dart';
import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/theme/sizeConfig.dart';
import 'package:fidelityride/view/pickupdrop/vehicle_selection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Function to get current location
  Future<Position?> _getCurrentLocation() async {
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
        // Permissions are permanently denied
        return null;
      }

      // Get the current position
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              AppData.appicon,
              width: SizeConfig.screenWidth / 2,
              height: 50,
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
              // Search Bar
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
                          children: const [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Text("Where to?", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _recentLocation(
                context,
                "Sandton City Mall",
                "Johannesburg",
                "OR Tambo International Airport", // Drop location
                -26.1337, // Drop lat
                28.2420, // Drop lng
              ),
              const SizedBox(height: 10),
              _recentLocation(
                context,
                "V&A Waterfront",
                "Cape Town",
                "Table Mountain", // Drop location
                -33.9628, // Drop lat
                18.4098, // Drop lng
              ),
              const SizedBox(height: 12),
              // Quick Types
              Text(
                'Book a Ride',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 100,
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

              const SizedBox(height: 24),

              const SizedBox(height: 12),
              SizedBox(
                height: 140,
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
    double dropLat,
    double dropLng,
  ) {
    return GestureDetector(
      onTap: () async {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        // Get current location
        Position? currentPosition = await _getCurrentLocation();

        // Remove loading indicator
        Navigator.of(context).pop();

        if (currentPosition != null) {
          // Navigate to RideOptionsScreen with current location as pickup
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => RideOptionsScreen(
                    pickupLocation: "Current Location",
                    dropLocation: dropLocation,
                    pickupLatLng: LatLng(
                      currentPosition.latitude,
                      currentPosition.longitude,
                    ),
                    dropLatLng: LatLng(dropLat, dropLng),
                  ),
            ),
          );
        } else {
          // Handle case when location is not available
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
            const Icon(Icons.history, color: Colors.black),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
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
                width: 50,
                height: 50,
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
}
