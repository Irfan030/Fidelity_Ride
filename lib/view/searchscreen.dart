// import 'package:fidelityride/view/route_mapscreen.dart';
// import 'package:flutter/material.dart';
//
// import 'location_screen.dart';
//
// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   String pickup = "";
//   String drop = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Set Pickup & Drop")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 labelText: "Pickup Location",
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.map),
//                   onPressed: () async {
//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => SelectLocationScreen()),
//                     );
//                     if (result != null) setState(() => pickup = result);
//                   },
//                 ),
//               ),
//               onChanged: (val) => pickup = val,
//             ),
//             SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: "Drop Location",
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.map),
//                   onPressed: () async {
//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => SelectLocationScreen()),
//                     );
//                     if (result != null) setState(() => drop = result);
//                   },
//                 ),
//               ),
//               onChanged: (val) => drop = val,
//             ),
//             Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 if (pickup.isNotEmpty && drop.isNotEmpty) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (_) => RouteMapScreen(pickup: pickup, drop: drop),
//                     ),
//                   );
//                 }
//               },
//               child: Text("Show Route"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:fidelityride/view/route_mapscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();

  String selectedField = 'pickup';
  String pickup = '';
  String drop = '';

  List<String> suggestions = [];

  final String _apiKey = "AIzaSyDEQuMizKGG3iBx96RZWckPjQso8lFQ6V4";

  Future<void> fetchSuggestions(String input) async {
    if (input.isEmpty) return;

    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&components=country:in&language=en&key=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      print("Request URL: $url");
      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'REQUEST_DENIED') {
          print("API Error: ${data['error_message']}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Location services not available. Please check API configuration.",
              ),
            ),
          );
          return;
        }

        final predictions = data['predictions'] as List;
        setState(() {
          suggestions =
              predictions.map((p) => p['description'] as String).toList();
        });
      } else {
        setState(() => suggestions = []);
        print("Google API error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => suggestions = []);
      print("Exception: $e");
    }
  }

  void handleSelect(String value) {
    setState(() {
      if (selectedField == 'pickup') {
        pickup = value;
        pickupController.text = value;
      } else {
        drop = value;
        dropController.text = value;
      }
      suggestions.clear();
    });
  }

  void proceedToMap() {
    if (pickup.isNotEmpty && drop.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RouteMapScreen(pickup: pickup, drop: drop),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select both locations")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Your Route")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: pickupController,
              decoration: InputDecoration(labelText: "Pickup Location"),
              onTap: () => selectedField = 'pickup',
              onChanged: fetchSuggestions,
            ),
            SizedBox(height: 10),
            TextField(
              controller: dropController,
              decoration: InputDecoration(labelText: "Drop Location"),
              onTap: () => selectedField = 'drop',
              onChanged: fetchSuggestions,
            ),
            if (suggestions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder:
                      (context, index) => ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(suggestions[index]),
                        onTap: () => handleSelect(suggestions[index]),
                      ),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: proceedToMap, child: Text("Show on Map")),
          ],
        ),
      ),
    );
  }
}
