import 'package:fidelityride/constant.dart';
import 'package:fidelityride/route/routePath.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              AppData.appicon,
              width: 150,
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
                  Navigator.pushNamed(
                    context,
                    RoutePath.searchScreen,
                  ); // 👈 navigate
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
              // Recent locations
              _recentLocation("Nagapattinam", "Tamil Nadu"),
              const SizedBox(height: 10),
              _recentLocation("Karaikal", "Puducherry"),
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

  Widget _recentLocation(String title, String subtitle) {
    return Container(
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
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageAsset, width: 50, height: 50, fit: BoxFit.contain),
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
