import 'package:fidelityride/route/routePath.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topServices = [
      {'title': 'Standard Cab', 'image': 'assets/images/car_icon.png'},
      {'title': 'Armored Cab', 'image': 'assets/images/armored_icon.png'},
    ];

    final bottomServices = [
      {'title': 'Bike', 'image': 'assets/images/bike_icon.png'},
      {'title': 'XL Cab', 'image': 'assets/images/xl_car_icon.png'},
      {'title': 'Parcel', 'image': 'assets/images/parcel_icon.png'},
      {'title': 'XL Armored', 'image': 'assets/images/xl_car_icon.png'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Services",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Anywhere. Anything. Anytime. With Secure Drive.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),

            // First Row (2 Cards)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  topServices.map((service) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutePath.searchScreen);
                        },
                        child: Container(
                          height: 150,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  service['image'] as String,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                service['title']
                                    as String, // Explicitly cast to String
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 24),

            // Second Row (4 Cards)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bottomServices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final service = bottomServices[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutePath.searchScreen,
                    ); // 👈 navigate
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            service['image'] as String,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          service['title']
                              as String, // Explicitly cast to String
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
