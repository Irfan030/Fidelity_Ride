// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   double? lat;
//   double? long;
//   GoogleMapController? mapController;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _setCurrentLocationAndMarker();
//     });
//   }
//
//   Future<void> _setCurrentLocationAndMarker() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) return;
//     }
//     if (permission == LocationPermission.deniedForever) return;
//
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     lat = position.latitude;
//     long = position.longitude;
//
//     // Move camera to current location
//     mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: LatLng(lat!, long!), zoom: 15),
//       ),
//     );
//
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: Scaffold(
//         key: _scaffoldKey,
//         drawer: SizedBox(
//           width:
//               MediaQuery.of(context).size.width * 0.75 < 400
//                   ? MediaQuery.of(context).size.width * 0.75
//                   : 350,
//           child: Drawer(child: Center(child: Text('Drawer content here'))),
//         ),
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           automaticallyImplyLeading: false,
//           title: Row(
//             children: <Widget>[
//               GestureDetector(
//                 onTap: () {
//                   _scaffoldKey.currentState!.openDrawer();
//                 },
//                 child: Icon(
//                   Icons.dehaze,
//                   color: Theme.of(context).textTheme.titleLarge!.color,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Where are you going?',
//                       hintStyle: TextStyle(color: Colors.grey[600]),
//                       icon: Icon(Icons.search, color: Colors.grey[600]),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: Stack(
//           children: <Widget>[
//             GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(20.5937, 78.9629), // India center fallback
//                 zoom: 5,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//                 setLDMapStyle(); // Load style after map ready
//               },
//               markers: Set<Marker>.of(getMarkerList(context).values),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Expanded(child: SizedBox()),
//                 myLocationButton(),
//                 SizedBox(height: 50),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget myLocationButton() {
//     return Padding(
//       padding: const EdgeInsets.only(right: 14),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           GestureDetector(
//             onTap: _setCurrentLocationAndMarker,
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Theme.of(context).primaryColor,
//                     blurRadius: 12,
//                     spreadRadius: -5,
//                     offset: Offset(0.0, 0),
//                   ),
//                 ],
//               ),
//               child: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                 child: Icon(
//                   Icons.my_location,
//                   color: Theme.of(context).textTheme.titleLarge!.color,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Map<MarkerId, Marker> getMarkerList(BuildContext context) {
//     Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//
//     if (lat != null && long != null) {
//       final MarkerId markerId = MarkerId("current_location");
//
//       final Marker marker = Marker(
//         markerId: markerId,
//         position: LatLng(lat!, long!),
//         anchor: Offset(0.5, 0.5),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//       );
//
//       markers[markerId] = marker;
//     }
//
//     return markers;
//   }
//
//   void setLDMapStyle() async {
//     if (mapController != null) {
//       try {
//         final isLightTheme = Theme.of(context).brightness == Brightness.light;
//         final stylePath =
//             isLightTheme
//                 ? "jsonFile/lightmapstyle.json"
//                 : "jsonFile/darkmapstyle.json";
//
//         final style = await DefaultAssetBundle.of(
//           context,
//         ).loadString(stylePath);
//         mapController?.setMapStyle(style);
//       } catch (e) {
//         print('Failed to set map style: $e');
//       }
//     }
//   }
// }
