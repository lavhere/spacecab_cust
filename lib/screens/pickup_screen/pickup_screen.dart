// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_maps_webservices/places.dart';
// import 'package:get/get.dart';
//
// import '../../controller/location_controller.dart';
//
//
// class PickupScreen extends StatelessWidget {
//    PickupScreen({Key? key}) : super(key: key);
//   final controller = Get.put(LocationController());
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pickup'),
//         leading: const BackButton(),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 children: [
//                   Obx(() => _locationField(
//                     label: "Pickup location",
//                     controller: controller.pickupController,
//                     color: Colors.green,
//                     hintText: "Enter pickup location",
//                     onChanged: (val) =>
//                         controller.onSearchChanged(val, true),
//                     suggestions: controller.pickupSuggestions,
//                     onSelect: (pred) =>
//                         controller.selectSuggestion(pred, true),
//                   )),
//                   const Divider(),
//                   Obx(() => _locationField(
//                     label: "Drop location",
//                     controller: controller.dropController,
//                     color: Colors.red,
//                     hintText: "Enter drop location",
//                     onChanged: (val) =>
//                         controller.onSearchChanged(val, false),
//                     suggestions: controller.dropSuggestions,
//                     onSelect: (pred) =>
//                         controller.selectSuggestion(pred, false),
//                   )),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () {
//                 print('Pickup: ${controller.pickupController.text}');
//                 print('Drop: ${controller.dropController.text}');
//               },
//               icon: const Icon(Icons.location_on_outlined),
//               label: const Text("Select on map"),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.black87,
//                 backgroundColor: Colors.white,
//                 elevation: 0,
//                 side: const BorderSide(color: Colors.black26),
//                 padding: EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: screenWidth > 400 ? 24 : 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _locationField({
//     required String label,
//     required TextEditingController controller,
//     required Color color,
//     required String hintText,
//     required Function(String) onChanged,
//     required List<Prediction> suggestions,
//     required Function(Prediction) onSelect,
//   }) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Icon(Icons.circle, color: color, size: 14),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(label,
//                       style: const TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 4),
//                   TextField(
//                     controller: controller,
//                     onChanged: onChanged,
//                     decoration: InputDecoration(
//                       hintText: hintText,
//                       contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.black26),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         if (suggestions.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.only(top: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: suggestions.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: const Icon(Icons.location_on_outlined),
//                   title: Text(suggestions[index].description ?? ''),
//                   onTap: () => onSelect(suggestions[index]),
//                 );
//               },
//             ),
//           )
//       ],
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:http/http.dart' as http;
import 'dart:convert';

class PickupScreen extends StatefulWidget {
  const PickupScreen({Key? key}) : super(key: key);

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();

  final GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey: 'AIzaSyCiJLymeCL0CTqTmcmPJ5T0lkLwA02OxWg',
  );

  GoogleMapController? _mapController;
  LatLng? _pickupLatLng;
  LatLng? _dropLatLng;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  Timer? _debounce;
  List<Prediction> _pickupSuggestions = [];
  List<Prediction> _dropSuggestions = [];

  @override
  void dispose() {
    pickupController.dispose();
    dropController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String text, bool isPickup) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (text.isNotEmpty) {
        _fetchSuggestions(text, isPickup);
      } else {
        setState(() {
          if (isPickup) {
            _pickupSuggestions.clear();
          } else {
            _dropSuggestions.clear();
          }
        });
      }
    });
  }

  void _fetchSuggestions(String input, bool isPickup) async {
    final response = await _places.autocomplete(
      input,
      language: "en",
      components: [Component(Component.country, "in")],
    );

    if (response.isOkay) {
      setState(() {
        if (isPickup) {
          _pickupSuggestions = response.predictions;
        } else {
          _dropSuggestions = response.predictions;
        }
      });
    } else {
      print('Suggestion Error: ${response.errorMessage}');
    }
  }

  void _selectSuggestion(Prediction prediction, bool isPickup) async {
    FocusScope.of(context).unfocus(); // Hide keyboard
    final latLng = await getLatLngFromAddress(prediction.description!);

    setState(() {
      if (isPickup) {
        pickupController.text = prediction.description!;
        _pickupLatLng = latLng;
        _pickupSuggestions.clear();
      } else {
        dropController.text = prediction.description!;
        _dropLatLng = latLng;
        _dropSuggestions.clear();
      }
      _updateMarkersAndPolyline();
    });
  }

  Future<LatLng> getLatLngFromAddress(String address) async {
    List<geocoding.Location> locations =
    await geocoding.locationFromAddress(address);
    return LatLng(locations.first.latitude, locations.first.longitude);
  }

  Future<void> _updateMarkersAndPolyline() async {
    if (_pickupLatLng != null && _dropLatLng != null) {
      final polylinePoints = await getPolylinePoints(_pickupLatLng!, _dropLatLng!);
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('pickup'),
            position: _pickupLatLng!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ),
          Marker(
            markerId: const MarkerId('drop'),
            position: _dropLatLng!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        };
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: polylinePoints,
          )
        };
        _mapController?.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              _pickupLatLng!.latitude < _dropLatLng!.latitude
                  ? _pickupLatLng!.latitude
                  : _dropLatLng!.latitude,
              _pickupLatLng!.longitude < _dropLatLng!.longitude
                  ? _pickupLatLng!.longitude
                  : _dropLatLng!.longitude,
            ),
            northeast: LatLng(
              _pickupLatLng!.latitude > _dropLatLng!.latitude
                  ? _pickupLatLng!.latitude
                  : _dropLatLng!.latitude,
              _pickupLatLng!.longitude > _dropLatLng!.longitude
                  ? _pickupLatLng!.longitude
                  : _dropLatLng!.longitude,
            ),
          ),
          100,
        ));
      });
    }
  }

  Future<List<LatLng>> getPolylinePoints(LatLng start, LatLng end) async {
    final url = "https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=AIzaSyCiJLymeCL0CTqTmcmPJ5T0lkLwA02OxWg";
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['routes'].isEmpty) return [];

    final points = data['routes'][0]['overview_polyline']['points'];
    return decodePolyline(points);
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;
      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return poly;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup'),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _locationField(
                  label: "Pickup location",
                  controller: pickupController,
                  color: Colors.green,
                  hintText: "Enter pickup location",
                  onChanged: (val) => _onSearchChanged(val, true),
                  suggestions: _pickupSuggestions,
                  onSelect: (pred) => _selectSuggestion(pred, true),
                ),
                const Divider(),
                _locationField(
                  label: "Drop location",
                  controller: dropController,
                  color: Colors.red,
                  hintText: "Enter drop location",
                  onChanged: (val) => _onSearchChanged(val, false),
                  suggestions: _dropSuggestions,
                  onSelect: (pred) => _selectSuggestion(pred, false),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(20.5937, 78.9629), // Center of India
                zoom: 5,
              ),
              polylines: _polylines,
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationField({
    required String label,
    required TextEditingController controller,
    required Color color,
    required String hintText,
    required Function(String) onChanged,
    required List<Prediction> suggestions,
    required Function(Prediction) onSelect,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.circle, color: color, size: 14),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: hintText,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(suggestions[index].description ?? ''),
                  onTap: () => onSelect(suggestions[index]),
                );
              },
            ),
          )
      ],
    );
  }
}

