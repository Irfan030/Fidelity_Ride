import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/theme/sizeConfig.dart';
import 'package:fidelityride/view/pickupdrop/get_location_map.dart';
import 'package:fidelityride/view/pickupdrop/vehicle_selection.dart';
import 'package:fidelityride/widget/defaultButton.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickupDropScreen extends StatefulWidget {
  const PickupDropScreen({super.key});

  @override
  State<PickupDropScreen> createState() => _PickupDropScreenState();
}

class _PickupDropScreenState extends State<PickupDropScreen> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final FocusNode pickupFocus = FocusNode();
  final FocusNode dropFocus = FocusNode();

  LatLng? pickupLatLng;
  LatLng? dropLatLng;

  bool isPickupFocused = true;
  bool isPickupEdited = false;
  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    pickupController.text = 'Your current location';

    pickupFocus.addListener(() {
      if (pickupFocus.hasFocus && !isPickupEdited) {
        pickupController.clear();
      } else if (!pickupFocus.hasFocus &&
          pickupController.text.trim().isEmpty) {
        setState(() {
          pickupController.text = 'Your current location';
          isPickupEdited = false;
        });
      }
    });

    dropFocus.addListener(() {
      if (dropFocus.hasFocus) {
        _onFieldTap(false);
      }
    });
  }

  @override
  void dispose() {
    pickupController.dispose();
    dropController.dispose();
    pickupFocus.dispose();
    dropFocus.dispose();
    super.dispose();
  }

  void _onFieldTap(bool isPickup) {
    setState(() {
      isPickupFocused = isPickup;
    });
  }

  void _onClear(bool isPickup) {
    setState(() {
      if (isPickup) {
        pickupController.clear();
        isPickupEdited = false;
      } else {
        dropController.clear();
      }
      suggestions.clear();
    });
  }

  void _onTextChanged(String value) {
    setState(() {
      if (isPickupFocused) {
        isPickupEdited = value.trim().isNotEmpty;
      }

      if (value.isNotEmpty) {
        suggestions =
            [
                  "Koyambedu Bus Stand",
                  "Adyar",
                  "Marina Beach",
                  "T Nagar",
                  "Tambaram",
                ]
                .where((s) => s.toLowerCase().contains(value.toLowerCase()))
                .toList();
      } else {
        suggestions.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: Text(isPickupFocused ? "Pickup" : "Drop"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 Pickup & Drop Fields
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Pickup field
                  Row(
                    children: [
                      const Icon(
                        Icons.radio_button_checked,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: pickupController,
                          focusNode: pickupFocus,
                          onTap: () => _onFieldTap(true),
                          onChanged: _onTextChanged,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (pickupController.text != 'Your current location' &&
                          pickupController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () => _onClear(true),
                          child: const Icon(Icons.close, size: 18),
                        ),
                    ],
                  ),
                  const Divider(height: 20),
                  // Drop field
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: dropController,
                          focusNode: dropFocus,
                          onTap: () => _onFieldTap(false),
                          onChanged: _onTextChanged,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter drop location",
                          ),
                        ),
                      ),
                      if (dropController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () => _onClear(false),
                          child: const Icon(Icons.close, size: 18),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => MapLocationPickerScreen(
                          title:
                              isPickupFocused
                                  ? "Select Pickup Location"
                                  : "Select Drop Location",
                        ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    if (isPickupFocused) {
                      pickupController.text = result['address'];
                      pickupLatLng = LatLng(
                        result['latitude'],
                        result['longitude'],
                      );
                      isPickupEdited = true;
                    } else {
                      dropController.text = result['address'];
                      dropLatLng = LatLng(
                        result['latitude'],
                        result['longitude'],
                      );
                    }
                    suggestions.clear();
                  });
                }
              },
              icon: const Icon(Icons.location_on_outlined),
              label: const Text("Select on map"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                foregroundColor: Colors.black,
                elevation: 0,
              ),
            ),

            Divider(thickness: 1),

            const SizedBox(height: 16),

            // In your PickupDropScreen, add this where you handle the "Book Ride" action
            Center(
              child: SizedBox(
                width: SizeConfig.screenWidth / 2,
                child: DefaultButton(
                  text: "Book Ride",
                  press: () {
                    if (pickupController.text.isNotEmpty &&
                        dropController.text.isNotEmpty &&
                        pickupLatLng != null &&
                        dropLatLng != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RideOptionsScreen(
                                pickupLocation: pickupController.text,
                                dropLocation: dropController.text,
                                pickupLatLng: pickupLatLng!,
                                dropLatLng: dropLatLng!,
                              ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColor.secondaryColor,
                          content: Text(
                            'Please select both pickup and drop locations on map',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),

            // 📌 Suggestion list
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.location_on_outlined),
                        Text("20 km"),
                      ],
                    ),
                    title: Text(suggestions[index]),
                    subtitle: const Text("Chennai, Tamil Nadu, India"),
                    onTap: () {
                      setState(() {
                        if (isPickupFocused) {
                          pickupController.text = suggestions[index];
                          isPickupEdited = true;
                        } else {
                          dropController.text = suggestions[index];
                        }
                        suggestions.clear();
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
