// imports...
import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/theme/sizeConfig.dart';
import 'package:fidelityride/view/pickupdrop/get_location_map.dart';
import 'package:fidelityride/view/pickupdrop/vehicle_selection.dart';
import 'package:fidelityride/widget/defaultButton.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mapservices/google_place_api.dart';

class PickupDropScreen extends StatefulWidget {
  const PickupDropScreen({super.key});

  @override
  State<PickupDropScreen> createState() => _PickupDropScreenState();
}

class _PickupDropScreenState extends State<PickupDropScreen> {
  final GooglePlaceService _placeService = GooglePlaceService();

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final FocusNode pickupFocus = FocusNode();
  final FocusNode dropFocus = FocusNode();

  bool isPickupFocused = true;
  bool isPickupEdited = false;
  bool isLoading = false;

  LatLng? pickupLatLng;
  LatLng? dropLatLng;

  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();

    pickupFocus.addListener(() {
      if (pickupFocus.hasFocus) {
        _onFieldTap(true);
        if (!isPickupEdited) pickupController.clear();
      } else if (!pickupFocus.hasFocus &&
          pickupController.text.trim().isEmpty) {
        _setCurrentLocation();
        isPickupEdited = false;
      }
    });

    dropFocus.addListener(() {
      if (dropFocus.hasFocus) _onFieldTap(false);
    });
  }

  void _onFieldTap(bool isPickup) {
    setState(() {
      isPickupFocused = isPickup;
    });

    final controller = isPickup ? pickupController : dropController;
    if (controller.text.trim().isEmpty) {
      loadRecentSearches();
    }
  }

  void _onTextChanged(String value) async {
    if (isPickupFocused) {
      isPickupEdited = value.trim().isNotEmpty;
    }

    if (value.isNotEmpty) {
      final results = await _placeService.fetchSuggestions(value);
      setState(() => suggestions = results);
    } else {
      loadRecentSearches(); // show recent again when field is cleared
    }
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

  Future<void> _setCurrentLocation() async {
    try {
      setState(() => isLoading = true);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        pickupLatLng = LatLng(position.latitude, position.longitude);

        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          String address =
              "${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

          setState(() {
            pickupController.text = address;
          });
        }
      }
    } catch (e) {
      print("Location error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveRecentSearch(String address, bool isPickup) async {
    final prefs = await SharedPreferences.getInstance();
    final key = isPickup ? 'recent_pickups' : 'recent_drops';
    List<String> recent = prefs.getStringList(key) ?? [];

    recent.remove(address);
    recent.insert(0, address);

    if (recent.length > 5) recent = recent.sublist(0, 5);

    await prefs.setStringList(key, recent);
  }

  Future<void> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final key = isPickupFocused ? 'recent_pickups' : 'recent_drops';
    final recent = prefs.getStringList(key) ?? [];

    setState(() {
      suggestions = recent;
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                _buildLocationFields(),
                const SizedBox(height: 16),
                _buildMapButton(),
                const Divider(thickness: 1),
                const SizedBox(height: 16),
                _buildBookButton(),
                _buildSuggestionsList(),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildLocationFields() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.radio_button_checked, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: pickupController,
                  focusNode: pickupFocus,
                  onTap: () => _onFieldTap(true),
                  onChanged: _onTextChanged,
                  decoration: const InputDecoration(
                    hintText: "Enter Pickup Location",
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (pickupController.text.isNotEmpty)
                GestureDetector(
                  onTap: () => _onClear(true),
                  child: const Icon(Icons.close, size: 18),
                ),
            ],
          ),
          const Divider(height: 20),
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
                    hintText: "Enter Drop Location",
                    border: InputBorder.none,
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
    );
  }

  Widget _buildMapButton() {
    return ElevatedButton.icon(
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
          final address = result['address'];
          final latLng = LatLng(result['latitude'], result['longitude']);

          setState(() {
            if (isPickupFocused) {
              pickupController.text = address;
              pickupLatLng = latLng;
              isPickupEdited = true;
            } else {
              dropController.text = address;
              dropLatLng = latLng;
            }
            suggestions.clear();
          });

          // Save recent search
          await saveRecentSearch(address, isPickupFocused);
        }
      },
      icon: const Icon(Icons.location_on_outlined),
      label: const Text("Select on map"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[100],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
    );
  }

  Widget _buildBookButton() {
    return Center(
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
                      (_) => RideOptionsScreen(
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
    );
  }

  Widget _buildSuggestionsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (_, index) {
          final suggestion = suggestions[index];
          return ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(suggestion.split(',')[0]),
            subtitle: Text(suggestion.split(',').skip(1).join(',').trim()),
            onTap: () async {
              setState(() => isLoading = true);

              final result = await _placeService.fetchPlaceDetails(suggestion);

              if (result != null) {
                final latLng = LatLng(result['latitude'], result['longitude']);

                setState(() {
                  if (isPickupFocused) {
                    pickupController.text = suggestion;
                    pickupLatLng = latLng;
                    isPickupEdited = true;
                  } else {
                    dropController.text = suggestion;
                    dropLatLng = latLng;
                  }
                  suggestions.clear();
                });

                await saveRecentSearch(suggestion, isPickupFocused);
              }

              setState(() => isLoading = false);
            },
          );
        },
      ),
    );
  }
}
