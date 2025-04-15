import 'package:fidelityride/theme/colors.dart';
import 'package:fidelityride/widget/defaultButton.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationPickerScreen extends StatefulWidget {
  final String title;

  const MapLocationPickerScreen({super.key, required this.title});

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(11.017, 79.856);
  String _currentAddress = "Fetching address...";

  @override
  void initState() {
    super.initState();
    _goToMyLocation(); // Automatically center to current location on start
  }

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
  }
  //this below code is show exact building name now our issue in google place api

  // I/flutter (27933): API Response: {
  // I/flutter (27933):    "error_message" : "This IP, site or mobile application is not authorized to use this API key. Request received from IP address 106.197.108.177, with empty referer",
  // I/flutter (27933):    "results" : [],
  // I/flutter (27933):    "status" : "REQUEST_DENIED"
  // I/flutter (27933): }
  // I/flutter (27933): Geocode status: REQUEST_DENIED

  // Future<String> getReadableAddressFromGoogle(double lat, double lng) async {
  //   final url =
  //       "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDEQuMizKGG3iBx96RZWckPjQso8lFQ6V4";
  //
  //   final response = await http.get(Uri.parse(url));
  //
  //   print("API Response: ${response.body}");
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     if (data['status'] == 'OK' && data['results'].isNotEmpty) {
  //       return data['results'][0]['formatted_address'];
  //     } else {
  //       print("Geocode status: ${data['status']}");
  //       return 'No address found';
  //     }
  //   } else {
  //     print("HTTP error: ${response.statusCode}");
  //     return 'Error fetching address';
  //   }
  // }
  //
  // void _onCameraIdle() async {
  //   try {
  //     final formattedAddress = await getReadableAddressFromGoogle(
  //       _center.latitude,
  //       _center.longitude,
  //     );
  //
  //     setState(() {
  //       _currentAddress = formattedAddress;
  //     });
  //   } catch (e) {
  //     print("Error fetching address: $e");
  //     setState(() {
  //       _currentAddress = "Unable to fetch address";
  //     });
  //   }
  // }

  // void _onCameraIdle() async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       _center.latitude,
  //       _center.longitude,
  //     );
  //
  //     if (placemarks.isNotEmpty) {
  //       final place = placemarks.first;
  //
  //       // Compose address like Uber (Landmark first, then street, city etc.)
  //       final name = place.name ?? '';
  //       final street = place.street ?? '';
  //       final locality = place.locality ?? '';
  //       final state = place.administrativeArea ?? '';
  //       final postal = place.postalCode ?? '';
  //       final country = place.country ?? '';
  //
  //       setState(() {
  //         _currentAddress =
  //             "$name, $street, $locality, $state $postal, $country";
  //       });
  //     }
  //   } catch (e) {
  //     print("Reverse geocoding error: $e");
  //     setState(() {
  //       _currentAddress = "Unable to fetch address";
  //     });
  //   }
  // }

  void _onCameraIdle() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _center.latitude,
        _center.longitude,
      );

      if (!mounted)
        return; // 🛡️ Prevent calling setState if widget is disposed

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final name = place.name ?? '';
        final street = place.street ?? '';
        final locality = place.locality ?? '';
        final state = place.administrativeArea ?? '';
        final postal = place.postalCode ?? '';
        final country = place.country ?? '';

        setState(() {
          _currentAddress =
              "$name, $street, $locality, $state $postal, $country";
        });
      }
    } catch (e) {
      print("Reverse geocoding error: $e");

      if (!mounted) return;

      setState(() {
        _currentAddress = "Unable to fetch address";
      });
    }
  }

  Future<void> _goToMyLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _center = LatLng(position.latitude, position.longitude);

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: _center, zoom: 16)),
    );

    _onCameraIdle(); // update address
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🗺️ Map
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _center, zoom: 16),
              onMapCreated: (controller) => _mapController = controller,
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),

          /// 📍 Center pin
          Center(
            child: Icon(
              Icons.location_pin,
              size: 48,
              color: AppColor.mainColor,
            ),
          ),

          /// 🔙 Back & 📍 Location buttons
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: _goToMyLocation,
              ),
            ),
          ),

          /// ⬇️ Bottom container with address and confirm
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Address
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: DefaultButton(
                      text:
                          widget.title.contains("Drop")
                              ? "Select Drop"
                              : "Select Pickup",
                      press: () {
                        Navigator.pop(context, {
                          'address': _currentAddress,
                          'latitude': _center.latitude,
                          'longitude': _center.longitude,
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
