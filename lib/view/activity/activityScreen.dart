import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  final List<Map<String, dynamic>> activities = const [
    {
      "title": "34/19, 2nd Ave",
      "date": "18 Sept · 19:06",
      "amount": "₹0.00 · Cancelled",
      "icon": Icons.directions_car,
    },
    {
      "title": "Uber Auto",
      "date": "26 May · 19:53",
      "amount": "₹0.00 · Cancelled",
      "icon": Icons.electric_rickshaw,
    },
    {
      "title": "2nd Street",
      "date": "26 May · 09:46",
      "amount": "₹176.00",
      "icon": Icons.directions_car,
    },
    {
      "title": "85, PT Rajan Rd, near Oppsit Ag dms",
      "date": "26 May · 08:05",
      "amount": "₹0.00 · Cancelled",
      "icon": Icons.directions_car,
    },
    {
      "title": "Uber Go",
      "date": "26 May · 08:03",
      "amount": "₹0.00 · Cancelled",
      "icon": Icons.directions_car,
    },
    {
      "title": "Uber Go",
      "date": "26 May · 08:01",
      "amount": "₹0.00 · Cancelled",
      "icon": Icons.directions_car,
    },
    {
      "title": "Zaitoon Restaurant, Anna Nagar",
      "date": "11 May · 19:34",
      "amount": "₹220.00",
      "icon": Icons.directions_car,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Activity",
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
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            leading: Icon(activity['icon'], size: 40),
            title: Text(
              activity['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity['date']),
                Text(
                  activity['amount'],
                  style: TextStyle(
                    color:
                        activity['amount'].contains("Cancelled")
                            ? Colors.red
                            : Colors.black,
                  ),
                ),
              ],
            ),
            trailing: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh),
              label: const Text("Rebook"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
