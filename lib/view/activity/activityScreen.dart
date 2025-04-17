import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/view/pickupdrop/vehicle_selection.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  final List<Map<String, dynamic>> activities = const [
    {
      "title": "Sandton to OR Tambo",
      "date": "18 Apr · 10:15",
      "amount": "R180.00",
      "icon": Icons.directions_car,
      "pickup": "Sandton City Mall, Johannesburg",
      "drop": "OR Tambo International Airport, Kempton Park",
      "pickupLat": -26.1087,
      "pickupLng": 28.0567,
      "dropLat": -26.1337,
      "dropLng": 28.2420,
    },
    {
      "title": "V&A Waterfront to Table Mountain",
      "date": "16 Apr · 12:45",
      "amount": "R120.00",
      "icon": Icons.directions_car,
      "pickup": "V&A Waterfront, Cape Town",
      "drop": "Table Mountain, Cape Town",
      "pickupLat": -33.9068,
      "pickupLng": 18.4207,
      "dropLat": -33.9628,
      "dropLng": 18.4098,
    },
    {
      "title": "University of Pretoria to Menlyn Mall",
      "date": "14 Apr · 08:30",
      "amount": "R75.00",
      "icon": Icons.directions_car,
      "pickup": "University of Pretoria, Pretoria",
      "drop": "Menlyn Park Mall, Pretoria",
      "pickupLat": -25.7545,
      "pickupLng": 28.2314,
      "dropLat": -25.7845,
      "dropLng": 28.2752,
    },
    {
      "title": "Nelson Mandela Square to Montecasino",
      "date": "13 Apr · 19:20",
      "amount": "R110.00",
      "icon": Icons.directions_car,
      "pickup": "Nelson Mandela Square, Sandton",
      "drop": "Montecasino, Fourways",
      "pickupLat": -26.1069,
      "pickupLng": 28.0569,
      "dropLat": -26.0236,
      "dropLng": 28.0121,
    },
    {
      "title": "King Shaka Airport to Gateway Mall",
      "date": "10 Apr · 07:15",
      "amount": "R90.00",
      "icon": Icons.directions_car,
      "pickup": "King Shaka International Airport, Durban",
      "drop": "Gateway Theatre of Shopping, Durban",
      "pickupLat": -29.6144,
      "pickupLng": 31.1197,
      "dropLat": -29.7255,
      "dropLng": 31.0644,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Activity",
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
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            12,
            12,
            12,
            24,
          ), // Add more bottom padding here
          itemCount: activities.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final activity = activities[index];
            final isCancelled = activity['amount'].toString().contains(
              "Cancelled",
            );

            return Card(
              color: AppColor.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          activity['icon'],
                          size: 36,
                          color: AppColor.mainColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity['pickup'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Icon(Icons.arrow_downward, size: 14),
                                  SizedBox(width: 4),
                                  Text("to"),
                                ],
                              ),
                              Text(
                                activity['drop'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activity['date'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          activity['amount'],
                          style: TextStyle(
                            color: isCancelled ? Colors.red : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => RideOptionsScreen(
                                    pickupLocation: activity['pickup'],
                                    dropLocation: activity['drop'],
                                    pickupLatLng: LatLng(
                                      activity['pickupLat'],
                                      activity['pickupLng'],
                                    ),
                                    dropLatLng: LatLng(
                                      activity['dropLat'],
                                      activity['dropLng'],
                                    ),
                                  ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text("Rebook"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.mainColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
