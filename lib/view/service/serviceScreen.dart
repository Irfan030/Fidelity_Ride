import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topServices = [
      {'title': 'Standard Cab', 'icon': Icons.local_taxi},
      {'title': 'Armored Cab', 'icon': Icons.security},
    ];

    final bottomServices = [
      {'title': 'XL Cab', 'icon': Icons.airport_shuttle},
      {'title': 'Escort', 'icon': Icons.group},
      // {'title': 'Executive', 'icon': Icons.business_center},
      {'title': 'Parcel', 'icon': Icons.local_shipping},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Services",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColor.secondaryColor,
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
                      child: Container(
                        height: 150,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Expanded(
                              child: Icon(
                                service['icon']
                                    as IconData, // Explicitly cast to IconData
                                size: 48,
                                color: AppColor.secondaryColor,
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
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(
                          service['icon']
                              as IconData, // Explicitly cast to IconData
                          size: 48,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service['title'] as String, // Explicitly cast to String
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
